From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi: libfc: fix seconds_since_last_reset
	calculation
Date: Mon, 20 Jun 2016 16:58:11 +0200
Message-ID: <7eea4ce5-8cc4-d982-57ac-ec6e8d8ba323@sandisk.com>
References: <20160617154737.633440-1-arnd@arndb.de>
 <76a47d73-26e2-5a9f-7a03-21c72ca613ca@sandisk.com>
 <3671744.A3ustGCdmM@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <3671744.A3ustGCdmM@wuerfel>
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
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vasu Dev <vasu.dev@intel.com>, "y2038@lists.linaro.org" <y2038@lists.linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "fcoe-devel@open-fcoe.org" <fcoe-devel@open-fcoe.org>
List-Id: linux-scsi@vger.kernel.org

T24gMDYvMjAvMjAxNiAwNDo0OCBQTSwgQXJuZCBCZXJnbWFubiB3cm90ZToKPiBPbiBNb25kYXks
IEp1bmUgMjAsIDIwMTYgMzo1NDowNiBQTSBDRVNUIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToKPj4g
T24gMDYvMTcvMjAxNiAwNTo0NyBQTSwgQXJuZCBCZXJnbWFubiB3cm90ZToKPj4+IC0gICAgIGpp
ZmZpZXNfdG9fdGltZXNwZWMoamlmZmllcywgJnYwKTsKPj4+IC0gICAgIGppZmZpZXNfdG9fdGlt
ZXNwZWMobHBvcnQtPmJvb3RfdGltZSwgJnYxKTsKPj4+IC0gICAgIGZjX3N0YXRzLT5zZWNvbmRz
X3NpbmNlX2xhc3RfcmVzZXQgPSAodjAudHZfc2VjIC0gdjEudHZfc2VjKTsKPj4+ICsgICAgIGZj
X3N0YXRzLT5zZWNvbmRzX3NpbmNlX2xhc3RfcmVzZXQgPSAobHBvcnQtPmJvb3RfdGltZSAtIGpp
ZmZpZXMpIC8gSFo7Cj4+Cj4+IERvZXMgdGhpcyBwYXRjaCBpbnRyb2R1Y2UgYSA2NC1iaXQgZGl2
aXNpb24/IFRoZXJlIG1pZ2h0IHN0aWxsIGJlIDMyLWJpdAo+PiB1c2VycyBvZiB0aGlzIGNvZGUu
Cj4KPiBObywgYm90aCBscG9ydC0+Ym9vdF90aW1lIGFuZCBqaWZmaWVzIGFyZSAndW5zaWduZWQg
bG9uZycuCgpBaCwgeW91J3JlIHJpZ2h0LiBIZW5jZToKClJldmlld2VkLWJ5OiBCYXJ0IFZhbiBB
c3NjaGUgPGJhcnQudmFuYXNzY2hlQHNhbmRpc2suY29tPgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpZMjAzOCBtYWlsaW5nIGxpc3QKWTIwMzhAbGlzdHMu
bGluYXJvLm9yZwpodHRwczovL2xpc3RzLmxpbmFyby5vcmcvbWFpbG1hbi9saXN0aW5mby95MjAz
OAo=
