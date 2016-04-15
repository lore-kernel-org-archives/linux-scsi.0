From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] mpt3sas: Remove usage of 'struct timeval'
Date: Fri, 15 Apr 2016 09:16:18 +0200
Message-ID: <1561298.UGYTUHuOD6@c203>
References: <20160413070140.GA35235@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20160413070140.GA35235@localhost>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: jejb@linux.vnet.ibm.com, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, y2038@lists.linaro.org, linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com
List-Id: linux-scsi@vger.kernel.org

T24gTWl0dHdvY2gsIDEzLiBBcHJpbCAyMDE2IDAwOjAxOjQwIENFU1QgVGluYSBSdWNoYW5kYW5p
IHdyb3RlOgo+ICdzdHJ1Y3QgdGltZXZhbCcgd2lsbCBoYXZlIGl0cyB0dl9zZWMgdmFsdWUgb3Zl
cmZsb3cgb24gMzItYml0IHN5c3RlbXMKPiBpbiB5ZWFyIDIwMzggYW5kIGJleW9uZC4gVGhpcyBw
YXRjaCByZXBsYWNlcyB0aGUgdXNlIG9mIHN0cnVjdCB0aW1ldmFsCj4gZm9yIGNvbXB1dGluZyBt
cGlfcmVxdWVzdC5UaW1lU3RhbXAsIGFuZCBpbnN0ZWFkIHVzZXMga3RpbWVfdCB3aGljaCBwcm92
aWRlcwo+IDY0LWJpdCBzZWNvbmRzIHZhbHVlLiBUaGUgdGltZXN0YW1wIGNvbXB1dGVkIHJlbWFp
bnMgdW5hZmZlY3RlZCAobWlsbGlzZWNvbmRzCj4gc2luY2UgVW5peCBlcG9jaCkuCj4gCj4gU2ln
bmVkLW9mZi1ieTogVGluYSBSdWNoYW5kYW5pIDxydWNoYW5kYW5pLnRpbmFAZ21haWwuY29tPgo+
IFJldmlld2VkLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPgo+IC0tLQoKUmV2aWV3
ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8anRodW1zaGlybkBzdXNlLmRlPgoKLS0gCkpvaGFu
bmVzIFRodW1zaGlybiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgU3RvcmFnZQpqdGh1bXNoaXJuQHN1
c2UuZGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODkKU1VTRSBMSU5VWCBHbWJILCBNYXhmZWxkc3RyLiA1
LCA5MDQwOSBOw7xybmJlcmcKR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgSmFuZSBTbWl0aGFyZCwg
R3JhaGFtIE5vcnRvbgpIUkIgMjEyODQgKEFHIE7DvHJuYmVyZykKS2V5IGZpbmdlcnByaW50ID0g
RUMzOCA5Q0FCIEMyQzQgRjI1RCA4NjAwIEQwRDAgMDM5MyA5NjlEIDJENzYgMDg1MAoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWTIwMzggbWFpbGluZyBs
aXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6Ly9saXN0cy5saW5hcm8ub3JnL21haWxt
YW4vbGlzdGluZm8veTIwMzgK
