import { readFileSync } from "fs";
import { resolve } from "path";
import { db, pool } from "./src/index";

const sqlPath = resolve(import.meta.dirname ?? ".", "..", "adspot_db.sql");
const sql = readFileSync(sqlPath, "utf-8");

const lines = sql.split("\n");
const statements: string[] = [];
let buf = "";
let inCopy = false;

for (const line of lines) {
  if (line.startsWith("\\restrict") || line.startsWith("\\unrestrict") || line.startsWith("SET ")) continue;

  if (line.startsWith("COPY ")) {
    inCopy = true;
    continue;
  }
  if (inCopy) {
    if (line.trim() === "\\.") {
      inCopy = false;
      continue;
    }
    const vals = line.split("\t").map((v) => (v === "\\N" ? null : v));
    // This is a copy data line - skip for now, we can't easily convert
    continue;
  }

  buf += line + "\n";
  if (line.trim().endsWith(";")) {
    const stmt = buf.trim();
    if (stmt) statements.push(stmt);
    buf = "";
  }
}

for (const stmt of statements) {
  if (stmt.startsWith("--") || stmt.startsWith("ALTER TABLE ONLY")) continue;
  try {
    await pool.query(stmt);
  } catch (e: any) {
    const msg = e.message ?? String(e);
    if (msg.includes("already exists") || msg.includes("duplicate") || msg.includes("already a")) {
      // Expected - tables/types already created by drizzle
    } else {
      console.error("FAILED:", msg.slice(0, 200), "\nSQL:", stmt.slice(0, 100));
    }
  }
}

console.log("Schema import done. Running drizzle push for data...");
console.log("Note: COPY data cannot be imported this way - use the seed scripts instead.");
await pool.end();
