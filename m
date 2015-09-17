From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH v2 09/30] cxlflash: Fix to stop interrupt processing on
 remove
Date: Thu, 17 Sep 2015 11:58:19 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CB98C57@AcuExch.aculab.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1442438881-49507-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1442438881-49507-1-git-send-email-mrochs@linux.vnet.ibm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: "'Matthew R. Ochs'" <mrochs@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew
 Donnellan <andrew.donnellan@au1.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

RnJvbTogTGludXhwcGMtZGV2IE1hdHRoZXcgUi4gT2Nocw0KPiBTZW50OiAxNiBTZXB0ZW1iZXIg
MjAxNSAyMjoyOA0KPiBJbnRlcnJ1cHQgcHJvY2Vzc2luZyBjYW4gcnVuIGluIHBhcmFsbGVsIHRv
IGEgcmVtb3ZlIG9wZXJhdGlvbi4gVGhpcw0KPiBjYW4gbGVhZCB0byBhIGNvbmRpdGlvbiB3aGVy
ZSB0aGUgaW50ZXJydXB0IGhhbmRsZXIgaXMgcHJvY2Vzc2luZyB3aXRoDQo+IG1lbW9yeSB0aGF0
IGhhcyBiZWVuIGZyZWVkLg0KPiANCj4gVG8gYXZvaWQgcHJvY2Vzc2luZyBhbiBpbnRlcnJ1cHQg
d2hpbGUgbWVtb3J5IG1heSBiZSB5YW5rZWQsIGNoZWNrIGZvcg0KPiByZW1vdmFsIHdoaWxlIGlu
IHRoZSBpbnRlcnJ1cHQgaGFuZGxlci4gQmFpbCB3aGVuIHJlbW92YWwgaXMgaW1taW5lbnQuDQoN
Ck9uIHRoZSBmYWNlIG9mIGl0IHRoaXMganVzdCByZWR1Y2VzIHRoZSBzaXplIG9mIHRoZSB3aW5k
b3cgc29tZXdoYXQuDQoNCldoYXQgaGFwcGVucyBpZiB0aGUgaW50ZXJydXB0IHJvdXRpbmUgcmVh
ZHMgdGhlIGZsYWcganVzdCBiZWZvcmUgaXQgaXMgc2V0DQooc28gaXMgcHJvY2Vzc2luZyB0aGUg
ZW50cnkgdGhhdCBpcyBiZWluZyByZW1vdmVkKSBhbmQgaXMgdGhlbiAoc2F5KQ0KaW50ZXJydXB0
ZWQgYnkgYSBoaWdoZXIgcHJpb3JpdHkgaW50ZXJydXB0IHRoYXQgdGFrZXMgbG9uZ2VyIHRvIGV4
ZWN1dGUgdGhhbg0KdGhlIHJlbW92ZSBjb2RlPw0KDQpZb3UndmUgc3RpbGwgZ290IGFuIGludGVy
cnVwdCByb3V0aW5lIGFjY2Vzc2luZyBmcmVlZCBtZW1vcnkuDQoNCglEYXZpZA0KDQpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eHBwYy1kZXYgbWFp
bGluZyBsaXN0CkxpbnV4cHBjLWRldkBsaXN0cy5vemxhYnMub3JnCmh0dHBzOi8vbGlzdHMub3ps
YWJzLm9yZy9saXN0aW5mby9saW51eHBwYy1kZXY=
