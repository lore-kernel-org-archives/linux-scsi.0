From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [trivial PATCH V2] treewide: Align function definition
 open/close braces
Date: Thu, 22 Mar 2018 09:37:20 -0400
Message-ID: <20180322093720.2254cfbb@gandalf.local.home>
References: <5ccbbf083e26bddfb4ea4f819ed62347ce266f39.1521669820.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <5ccbbf083e26bddfb4ea4f819ed62347ce266f39.1521669820.git.joe@perches.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org, Alexandre Belloni <alexandre.belloni@bootlin.com>, x86@kernel.org, Xiubo Li <Xiubo.Lee@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Jeff Layton <jlayton@kernel.org>, Will Deacon <will.deacon@arm.com>, Timur Tabi <timur@tabi.org>, dri-devel@lists.freedesktop.org, Liam Girdwood <lgirdwood@gmail.com>, "J. Bruce Fields" <bfields@fieldses.org>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "H. Peter
 Anvin" <hpa@zytor.com>, linux-acpi@vger.kernel.org, linux-rtc@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Paul Moore <paul@paul-moore.com>, linux-scsi@vger.kernel.org, "Darrick J.
 Wong" <darrick.wong@oracle.com>, Dept-GELinuxNICDev@cavium.com, Mark Fasheh <mark@fasheh.com>, Sathya Prakash <sathya.prakash@broadcom.com>, amd-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>, Darren Hart <dvhart@infradead.org>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCAyMSBNYXIgMjAxOCAxNTowOTozMiAtMDcwMApKb2UgUGVyY2hlcyA8am9lQHBlcmNo
ZXMuY29tPiB3cm90ZToKCj4gZGlmZiAtLWdpdCBhL2tlcm5lbC90cmFjZS90cmFjZV9wcmludGsu
YyBiL2tlcm5lbC90cmFjZS90cmFjZV9wcmludGsuYwo+IGluZGV4IGFkMWQ2MTY0ZTk0Ni4uNTBm
NDRiN2IyYjMyIDEwMDY0NAo+IC0tLSBhL2tlcm5lbC90cmFjZS90cmFjZV9wcmludGsuYwo+ICsr
KyBiL2tlcm5lbC90cmFjZS90cmFjZV9wcmludGsuYwo+IEBAIC0xOTYsNyArMTk2LDcgQEAgc3Ry
dWN0IG5vdGlmaWVyX2Jsb2NrIG1vZHVsZV90cmFjZV9icHJpbnRrX2Zvcm1hdF9uYiA9IHsKPiAg
fTsKPiAgCj4gIGludCBfX3RyYWNlX2JwcmludGsodW5zaWduZWQgbG9uZyBpcCwgY29uc3QgY2hh
ciAqZm10LCAuLi4pCj4gLSB7Cj4gK3sKPiAgCWludCByZXQ7Cj4gIAl2YV9saXN0IGFwOwo+ICAK
PiBAQCAtMjE0LDcgKzIxNCw3IEBAIGludCBfX3RyYWNlX2JwcmludGsodW5zaWduZWQgbG9uZyBp
cCwgY29uc3QgY2hhciAqZm10LCAuLi4pCj4gIEVYUE9SVF9TWU1CT0xfR1BMKF9fdHJhY2VfYnBy
aW50ayk7Cj4gIAo+ICBpbnQgX19mdHJhY2VfdmJwcmludGsodW5zaWduZWQgbG9uZyBpcCwgY29u
c3QgY2hhciAqZm10LCB2YV9saXN0IGFwKQo+IC0gewo+ICt7Cj4gIAlpZiAodW5saWtlbHkoIWZt
dCkpCj4gIAkJcmV0dXJuIDA7Cj4gIAoKQWNrZWQtYnk6IFN0ZXZlbiBSb3N0ZWR0IChWTXdhcmUp
IDxyb3N0ZWR0QGdvb2RtaXMub3JnPgoKLS0gU3RldmUKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVsIG1haWxpbmcgbGlzdApkcmktZGV2ZWxA
bGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxt
YW4vbGlzdGluZm8vZHJpLWRldmVsCg==
