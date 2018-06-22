From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: Re: [PATCH] aacraid: stop using deprated get_seconds()
Date: Fri, 22 Jun 2018 17:23:18 +0000
Message-ID: <910e59ca484243edb838be21daa71547@microsemi.com>
References: <20180618152734.1705907-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20180618152734.1705907-1-arnd@arndb.de>
Content-Language: en-US
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Arnd Bergmann <arnd@arndb.de>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "y2038@lists.linaro.org" <y2038@lists.linaro.org>, Dave Carroll <david.carroll@microsemi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

CgoKPiBnZXRfc2Vjb25kcygpIGNhbiBvdmVyZmxvdyBvbiAzMi1iaXQgYXJjaGl0ZWN0dXJlcyBh
bmQgaXMgZGVwcmVjYXRlZAo+IGJlY2F1c2Ugb2YgdGhhdC4gVGhlIHVzZSBpbiB0aGUgYWFjcmFp
ZCBkcml2ZXIgaGFzIHRoZSBzYW1lIHByb2JsZW0gZHVlCj4gdG8gYSBsaW1pdGVkIGZpcm13YXJl
IGludGVyZmFjZSwgaXQgYWxzbyBvdmVyZmxvd3MgaW4gdGhlIHllYXIgMjEwNi4KPiAKPiBUaGlz
IGNoYW5nZXMgYWxsIGNhbGxzIHRvIGdldF9zZWNvbmRzKCkgdG8gdGhlIG5vbi1kZXByZWNhdGVk
Cj4ga3RpbWVfZ2V0X3JlYWxfc2Vjb25kcygpLCB3aGljaCB1bmZvcnR1bmF0ZWx5IGRvZXNuJ3Qg
c29sdmUgdGhhdCBwcm9ibGVtCj4gYnV0IGdldHMgcmlkIG9mIG9uZSB1c2VyIG9mIHRoZSBkZXBy
ZWNhdGVkIGludGVyZmFjZS4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5k
QGFybmRiLmRlPgo+IC0tLQpbLi4uXQpSZXZpZXdlZC1ieTogUmFnaGF2YSBBZGl0eWEgUmVudWt1
bnRhIDxSYWdoYXZhQWRpdHlhLlJlbnVrdW50YUBtaWNyb3NlbWkuY29tPgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpZMjAzOCBtYWlsaW5nIGxpc3QKWTIw
MzhAbGlzdHMubGluYXJvLm9yZwpodHRwczovL2xpc3RzLmxpbmFyby5vcmcvbWFpbG1hbi9saXN0
aW5mby95MjAzOAo=
