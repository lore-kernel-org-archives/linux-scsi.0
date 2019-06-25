From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v4 4/7] lib/hexdump.c: Replace ascii bool in
 hex_dump_to_buffer with flags
Date: Mon, 24 Jun 2019 22:01:40 -0700
Message-ID: <3340b520a57e00a483eae170be97316c8d18c22c.camel@perches.com>
References: <20190625031726.12173-1-alastair@au1.ibm.com>
 <20190625031726.12173-5-alastair@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <20190625031726.12173-5-alastair@au1.ibm.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: Alastair D'Silva <alastair@au1.ibm.com>, alastair@d-silva.org
Cc: linux-fbdev@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>, Petr Mladek <pmladek@suse.com>, David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>, ath10k@lists.infradead.org, intel-gfx@lists.freedesktop.org, Dan Carpenter <dan.carpenter@oracle.com>, Jose Abreu <Jose.Abreu@synopsys.com>, Tom Lendacky <thomas.lendacky@amd.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, linux-fsdevel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Kalle Valo <kvalo@codeaurora.org>, Karsten Keil <isdn@linux-pingi.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, David Laight <David.Laight@ACULAB.COM>
List-Id: linux-scsi@vger.kernel.org

T24gVHVlLCAyMDE5LTA2LTI1IGF0IDEzOjE3ICsxMDAwLCBBbGFzdGFpciBEJ1NpbHZhIHdyb3Rl
Ogo+IEZyb206IEFsYXN0YWlyIEQnU2lsdmEgPGFsYXN0YWlyQGQtc2lsdmEub3JnPgo+IAo+IElu
IG9yZGVyIHRvIHN1cHBvcnQgYWRkaXRpb25hbCBmZWF0dXJlcywgcmVuYW1lIGhleF9kdW1wX3Rv
X2J1ZmZlciB0bwo+IGhleF9kdW1wX3RvX2J1ZmZlcl9leHQsIGFuZCByZXBsYWNlIHRoZSBhc2Np
aSBib29sIHBhcmFtZXRlciB3aXRoIGZsYWdzLgpbXQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2dw
dS9kcm0vaTkxNS9pbnRlbF9lbmdpbmVfY3MuYyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2ludGVs
X2VuZ2luZV9jcy5jCltdCj4gQEAgLTEzMzgsOSArMTMzOCw4IEBAIHN0YXRpYyB2b2lkIGhleGR1
bXAoc3RydWN0IGRybV9wcmludGVyICptLCBjb25zdCB2b2lkICpidWYsIHNpemVfdCBsZW4pCj4g
IAkJfQo+ICAKPiAgCQlXQVJOX09OX09OQ0UoaGV4X2R1bXBfdG9fYnVmZmVyKGJ1ZiArIHBvcywg
bGVuIC0gcG9zLAo+IC0JCQkJCQlyb3dzaXplLCBzaXplb2YodTMyKSwKPiAtCQkJCQkJbGluZSwg
c2l6ZW9mKGxpbmUpLAo+IC0JCQkJCQlmYWxzZSkgPj0gc2l6ZW9mKGxpbmUpKTsKPiArCQkJCQkJ
cm93c2l6ZSwgc2l6ZW9mKHUzMiksIGxpbmUsCj4gKwkJCQkJCXNpemVvZihsaW5lKSkgPj0gc2l6
ZW9mKGxpbmUpKTsKCkh1aD8gIFdoeSBkbyB0aGlzPwoKPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9p
c2RuL2hhcmR3YXJlL21JU0ROL21JU0ROaXNhci5jIGIvZHJpdmVycy9pc2RuL2hhcmR3YXJlL21J
U0ROL21JU0ROaXNhci5jCltdCj4gQEAgLTcwLDggKzcwLDkgQEAgc2VuZF9tYm94KHN0cnVjdCBp
c2FyX2h3ICppc2FyLCB1OCBoaXMsIHU4IGNyZWcsIHU4IGxlbiwgdTggKm1zZykKPiAgCQkJaW50
IGwgPSAwOwo+ICAKPiAgCQkJd2hpbGUgKGwgPCAoaW50KWxlbikgewo+IC0JCQkJaGV4X2R1bXBf
dG9fYnVmZmVyKG1zZyArIGwsIGxlbiAtIGwsIDMyLCAxLAo+IC0JCQkJCQkgICBpc2FyLT5sb2cs
IDI1NiwgMSk7Cj4gKwkJCQloZXhfZHVtcF90b19idWZmZXJfZXh0KG1zZyArIGwsIGxlbiAtIGws
IDMyLCAxLAo+ICsJCQkJCQkgICAgICAgaXNhci0+bG9nLCAyNTYsCj4gKwkJCQkJCSAgICAgICBI
RVhEVU1QX0FTQ0lJKTsKCkFnYWluLCB3aHkgZG8gYW55IG9mIHRoZXNlPwoKVGhlIHBvaW50IG9m
IHRoZSB3cmFwcGVyIGlzIHRvIGF2b2lkIGNoYW5naW5nIHRoZXNlLgoKCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkludGVsLWdmeCBtYWlsaW5nIGxpc3QK
SW50ZWwtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczovL2xpc3RzLmZyZWVkZXNrdG9w
Lm9yZy9tYWlsbWFuL2xpc3RpbmZvL2ludGVsLWdmeA==
