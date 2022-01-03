#!/usr/bin/env node
/*
 * Copyright (c) 2018-2022 Yahweasel
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
 * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
 * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

(function() {
    var input = require("fs").readFileSync("ui.html", "utf8").split("\n");
    var out = "";
    var i = 0;
    for (; i < input.length; i++) {
        if (input[i].trim() === "<!--START-->")
            break;
    }
    for (; i < input.length; i++) {
        var line = input[i].trim();
        if (line === "<!--END-->")
            break;
        if (/<!--/.test(line))
            continue;
        out += line.replace(/ src="images\/watcher[^"]*"/, "");
    }
    process.stdout.write(`// This file was generated by mkuicode.js. Do not modify.\nexport const code = ${JSON.stringify(out)};\n`);
})();
