From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v5 04/34] cxlflash: Fix potential oops following LUN
 removal
Date: Fri, 2 Oct 2015 14:55:31 +0200
Message-ID: <560E7EC3.8060903@redhat.com>
References: <1443714773-9176-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1443714903-11876-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1443714903-11876-1-git-send-email-mrochs@linux.vnet.ibm.com>
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
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

T24gMS4xMC4yMDE1IDE3OjU1LCBNYXR0aGV3IFIuIE9jaHMgd3JvdGU6Cj4gV2hlbiBhIExVTiBp
cyByZW1vdmVkLCB0aGUgc2RldiB0aGF0IGlzIGFzc29jaWF0ZWQgd2l0aCB0aGUgTFVOCj4gcmVt
YWlucyBpbnRhY3QgdW50aWwgaXRzIHJlZmVyZW5jZSBjb3VudCBkcm9wcyB0byAwLiBJbiBvcmRl
cgo+IHRvIHByZXZlbnQgYW4gc2RldiBmcm9tIGJlaW5nIHJlbW92ZWQgd2hpbGUgYSBjb250ZXh0
IGlzIHN0aWxsCj4gYXNzb2NpYXRlZCB3aXRoIGl0LCBvYnRhaW4gYW4gYWRkaXRpb25hbCByZWZl
cmVuY2UgcGVyLWNvbnRleHQKPiBmb3IgZWFjaCBMVU4gYXR0YWNoZWQgdG8gdGhlIGNvbnRleHQu
Cj4KPiBUaGlzIHJlc29sdmVzIGEgcG90ZW50aWFsIE9vcHMgaW4gdGhlIHJlbGVhc2UgaGFuZGxl
ciB3aGVuIGEKPiBkZWFsaW5nIHdpdGggYSBMVU4gdGhhdCBoYXMgYWxyZWFkeSBiZWVuIHJlbW92
ZWQuCj4KPiBTaWduZWQtb2ZmLWJ5OiBNYXR0aGV3IFIuIE9jaHMgPG1yb2Noc0BsaW51eC52bmV0
LmlibS5jb20+Cj4gU2lnbmVkLW9mZi1ieTogTWFub2ogTi4gS3VtYXIgPG1hbm9qQGxpbnV4LnZu
ZXQuaWJtLmNvbT4KPiBSZXZpZXdlZC1ieTogQnJpYW4gS2luZyA8YnJraW5nQGxpbnV4LnZuZXQu
aWJtLmNvbT4KClJldmlld2VkLWJ5OiBUb21hcyBIZW56bCA8dGhlbnpsQHJlZGhhdC5jb20+CgpU
b21hcwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGlu
dXhwcGMtZGV2IG1haWxpbmcgbGlzdApMaW51eHBwYy1kZXZAbGlzdHMub3psYWJzLm9yZwpodHRw
czovL2xpc3RzLm96bGFicy5vcmcvbGlzdGluZm8vbGludXhwcGMtZGV2
