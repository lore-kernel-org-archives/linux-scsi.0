From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] fnic: Use time64_t to represent trace timestamps
Date: Tue, 4 Oct 2016 09:48:15 +0200
Message-ID: <20161004074815.7knnz4md64sse34y@linux-x5ow.site>
References: <1475365694-8582-1-git-send-email-deepa.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
Content-Disposition: inline
In-Reply-To: <1475365694-8582-1-git-send-email-deepa.kernel@gmail.com>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Suma Ramars <sramars@cisco.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, arnd@arndb.de, y2038@lists.linaro.org, Hiral Patel <hiralpat@cisco.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Brian Uchino <buchino@cisco.com>
List-Id: linux-scsi@vger.kernel.org

T24gU2F0LCBPY3QgMDEsIDIwMTYgYXQgMDQ6NDg6MTRQTSAtMDcwMCwgRGVlcGEgRGluYW1hbmkg
d3JvdGU6Cj4gdHJhY2UgdGltZXN0YW1wcyB1c2Ugc3RydWN0IHRpbWVzcGVjIGFuZCBDVVJSRU5U
X1RJTUUgd2hpY2gKPiBhcmUgbm90IHkyMDM4IHNhZmUuCj4gVGhlc2UgdGltZXN0YW1wcyBhcmUg
b25seSBwYXJ0IG9mIHRoZSB0cmFjZSBsb2cgb24gdGhlIG1hY2hpbmUKPiBhbmQgYXJlIG5vdCBz
aGFyZWQgd2l0aCB0aGUgZm5pYy4KPiBSZXBsYWNlIHRoZW4gd2l0aCB5MjAzOCBzYWZlIHN0cnVj
dCB0aW1lc3BlYzY0IGFuZAo+IGt0aW1lX2dldF9yZWFsX3RzNjQoKSwgcmVzcGVjdGl2ZWx5Lgo+
IAo+IFNpZ25lZC1vZmYtYnk6IERlZXBhIERpbmFtYW5pIDxkZWVwYS5rZXJuZWxAZ21haWwuY29t
Pgo+IFJldmlld2VkLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPgo+IENjOiBIaXJh
bCBQYXRlbCA8aGlyYWxwYXRAY2lzY28uY29tPgo+IENjOiBTdW1hIFJhbWFycyA8c3JhbWFyc0Bj
aXNjby5jb20+Cj4gQ2M6IEJyaWFuIFVjaGlubyA8YnVjaGlub0BjaXNjby5jb20+Cj4gQ2M6ICJK
YW1lcyBFLkouIEJvdHRvbWxleSIgPGplamJAbGludXgudm5ldC5pYm0uY29tPgo+IENjOiAiTWFy
dGluIEsuIFBldGVyc2VuIiA8bWFydGluLnBldGVyc2VuQG9yYWNsZS5jb20+Cj4gQ2M6IGxpbnV4
LXNjc2lAdmdlci5rZXJuZWwub3JnCj4gLS0tCgpMb29rcyBnb29kLApSZXZpZXdlZC1ieTogSm9o
YW5uZXMgVGh1bXNoaXJuIDxqdGh1bXNoaXJuQHN1c2UuZGU+CgotLSAKSm9oYW5uZXMgVGh1bXNo
aXJuICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgU3RvcmFnZQpqdGh1
bXNoaXJuQHN1c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQw
NTMgNjg5ClNVU0UgTElOVVggR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkdG
OiBGZWxpeCBJbWVuZMO2cmZmZXIsIEphbmUgU21pdGhhcmQsIEdyYWhhbSBOb3J0b24KSFJCIDIx
Mjg0IChBRyBOw7xybmJlcmcpCktleSBmaW5nZXJwcmludCA9IEVDMzggOUNBQiBDMkM0IEYyNUQg
ODYwMCBEMEQwIDAzOTMgOTY5RCAyRDc2IDA4NTAKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18KWTIwMzggbWFpbGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFy
by5vcmcKaHR0cHM6Ly9saXN0cy5saW5hcm8ub3JnL21haWxtYW4vbGlzdGluZm8veTIwMzgK
