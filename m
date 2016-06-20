From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: libfc: fix seconds_since_last_reset
	calculation
Date: Mon, 20 Jun 2016 16:50:01 +0200
Message-ID: <3671744.A3ustGCdmM@wuerfel>
References: <20160617154737.633440-1-arnd@arndb.de>
 <76a47d73-26e2-5a9f-7a03-21c72ca613ca@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <76a47d73-26e2-5a9f-7a03-21c72ca613ca@sandisk.com>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Vasu Dev <vasu.dev@intel.com>, y2038@lists.linaro.org, linux-kernel@vger.kernel.org, fcoe-devel@open-fcoe.org
List-Id: linux-scsi@vger.kernel.org

T24gTW9uZGF5LCBKdW5lIDIwLCAyMDE2IDM6NTQ6MDYgUE0gQ0VTVCBCYXJ0IFZhbiBBc3NjaGUg
d3JvdGU6Cj4gT24gMDYvMTcvMjAxNiAwNTo0NyBQTSwgQXJuZCBCZXJnbWFubiB3cm90ZToKPiA+
IC0gICAgIGppZmZpZXNfdG9fdGltZXNwZWMoamlmZmllcywgJnYwKTsKPiA+IC0gICAgIGppZmZp
ZXNfdG9fdGltZXNwZWMobHBvcnQtPmJvb3RfdGltZSwgJnYxKTsKPiA+IC0gICAgIGZjX3N0YXRz
LT5zZWNvbmRzX3NpbmNlX2xhc3RfcmVzZXQgPSAodjAudHZfc2VjIC0gdjEudHZfc2VjKTsKPiA+
ICsgICAgIGZjX3N0YXRzLT5zZWNvbmRzX3NpbmNlX2xhc3RfcmVzZXQgPSAobHBvcnQtPmJvb3Rf
dGltZSAtIGppZmZpZXMpIC8gSFo7Cj4gCj4gRG9lcyB0aGlzIHBhdGNoIGludHJvZHVjZSBhIDY0
LWJpdCBkaXZpc2lvbj8gVGhlcmUgbWlnaHQgc3RpbGwgYmUgMzItYml0IAo+IHVzZXJzIG9mIHRo
aXMgY29kZS4KCk5vLCBib3RoIGxwb3J0LT5ib290X3RpbWUgYW5kIGppZmZpZXMgYXJlICd1bnNp
Z25lZCBsb25nJy4KCglBcm5kCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fClkyMDM4IG1haWxpbmcgbGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3JnCmh0dHBz
Oi8vbGlzdHMubGluYXJvLm9yZy9tYWlsbWFuL2xpc3RpbmZvL3kyMDM4Cg==
