From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: Re: [PATCH v2 19/24] fnic: Use time64_t to represent trace
	timestamps
Date: Wed, 22 Jun 2016 18:51:21 -0700
Message-ID: <CABeXuvqUWcUEbbyO6K1y4ydw_-KFsPOdWgH5g1z61Pd=EXNnag@mail.gmail.com>
References: <1466382443-11063-1-git-send-email-deepa.kernel@gmail.com>
 <1466382443-11063-20-git-send-email-deepa.kernel@gmail.com>
 <8562537.c35I4lEtz8@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <8562537.c35I4lEtz8@wuerfel>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Suma Ramars <sramars@cisco.com>, Theodore Ts'o <tytso@mit.edu>, Linux SCSI List <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, y2038 Mailman List <y2038@lists.linaro.org>, Hiral Patel <hiralpat@cisco.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Brian Uchino <buchino@cisco.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

T24gV2VkLCBKdW4gMjIsIDIwMTYgYXQgNzowOSBBTSwgQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5k
Yi5kZT4gd3JvdGU6Cj4gT24gU3VuZGF5LCBKdW5lIDE5LCAyMDE2IDU6Mjc6MTggUE0gQ0VTVCBE
ZWVwYSBEaW5hbWFuaSB3cm90ZToKPj4gdHJhY2UgdGltZXN0YW1wcyB1c2Ugc3RydWN0IHRpbWVz
cGVjIGFuZCBDVVJSRU5UX1RJTUUgd2hpY2gKPj4gYXJlIG5vdCB5MjAzOCBzYWZlLgo+PiBUaGVz
ZSB0aW1lc3RhbXBzIGFyZSBvbmx5IHBhcnQgb2YgdGhlIHRyYWNlIGxvZyBvbiB0aGUgbWFjaGlu
ZQo+PiBhbmQgYXJlIG5vdCBzaGFyZWQgd2l0aCB0aGUgZm5pYy4KPj4gUmVwbGFjZSB0aGVuIHdp
dGggeTIwMzggc2FmZSBzdHJ1Y3QgdGltZXNwZWM2NCBhbmQKPj4ga3RpbWVfZ2V0X3JlYWxfdHM2
NCgpLCByZXNwZWN0aXZlbHkuCj4+Cj4+IE5vdGUgdGhhdCBjaGFuZ2UgdG8gYWRkIHRpbWU2NF90
b190bSgpIGlzIGFscmVhZHkgcGFydCBvZiBKb2huJ3MKPj4ga2VybmVsIHRyZWU6IGh0dHBzOi8v
bGttbC5vcmcvbGttbC8yMDE2LzYvMTcvODc1IC4KPj4KPgo+IFdoaWxlIHRoZSBwYXRjaCBsb29r
cyBnb29kLCBJIHRoaW5rIGl0IGNhbid0IGJlIHBhcnQgb2YgdGhpcwo+IHNlcmllcyBub3csIHNp
bmNlIGl0IGhhcyB0byBnbyBvbiB0b3Agb2YgdGhhdCBmaXJzdCBwYXRjaCwKPiByYXRoZXIgdGhh
biBtZXJnZWQgaW4gcGFyYWxsZWwuCgpPaCwgSSBkaWRuJ3QgcmVhbGl6ZSB3ZSBjb3VsZCBtZXJn
ZSB0aGVzZSBpbiBwYXJhbGxlbC4KSSB0aG91Z2h0IHRoZSB0aW1lNjRfdG9fdG0oKSBoYWQgdG8g
Z28gaW4gZmlyc3QuCgo+IFdoZW4geW91IHNlbmQgYSBwdWxsIHJlcXVlc3QsIHBsZWFzZSBsZWF2
ZSBpdCBvdXQgYW5kIHN1Ym1pdAo+IHRoaXMgb25lIHNlcGFyYXRlbHkgYWZ0ZXIgNC44LXJjMS4K
CldpbGwgZG8uCgpUaGFua3MsCkRlZXBhCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fClkyMDM4IG1haWxpbmcgbGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3Jn
Cmh0dHBzOi8vbGlzdHMubGluYXJvLm9yZy9tYWlsbWFuL2xpc3RpbmZvL3kyMDM4Cg==
