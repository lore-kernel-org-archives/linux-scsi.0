From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] aacraid: stop using deprated get_seconds()
Date: Tue, 26 Jun 2018 11:57:45 -0400
Message-ID: <yq11sct5yme.fsf@oracle.com>
References: <20180618152734.1705907-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20180618152734.1705907-1-arnd@arndb.de> (Arnd Bergmann's message
 of "Mon, 18 Jun 2018 17:26:47 +0200")
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
Cc: Dave Carroll <david.carroll@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, y2038@lists.linaro.org, linux-kernel@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@microsemi.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
List-Id: linux-scsi@vger.kernel.org

CkFybmQsCgo+IGdldF9zZWNvbmRzKCkgY2FuIG92ZXJmbG93IG9uIDMyLWJpdCBhcmNoaXRlY3R1
cmVzIGFuZCBpcyBkZXByZWNhdGVkCj4gYmVjYXVzZSBvZiB0aGF0LiBUaGUgdXNlIGluIHRoZSBh
YWNyYWlkIGRyaXZlciBoYXMgdGhlIHNhbWUgcHJvYmxlbQo+IGR1ZSB0byBhIGxpbWl0ZWQgZmly
bXdhcmUgaW50ZXJmYWNlLCBpdCBhbHNvIG92ZXJmbG93cyBpbiB0aGUgeWVhcgo+IDIxMDYuCj4K
PiBUaGlzIGNoYW5nZXMgYWxsIGNhbGxzIHRvIGdldF9zZWNvbmRzKCkgdG8gdGhlIG5vbi1kZXBy
ZWNhdGVkCj4ga3RpbWVfZ2V0X3JlYWxfc2Vjb25kcygpLCB3aGljaCB1bmZvcnR1bmF0ZWx5IGRv
ZXNuJ3Qgc29sdmUgdGhhdAo+IHByb2JsZW0gYnV0IGdldHMgcmlkIG9mIG9uZSB1c2VyIG9mIHRo
ZSBkZXByZWNhdGVkIGludGVyZmFjZS4KCkFwcGxpZWQgdG8gNC4xOS9zY3NpLXF1ZXVlLiBUaGFu
a3MhCgotLSAKTWFydGluIEsuIFBldGVyc2VuCU9yYWNsZSBMaW51eCBFbmdpbmVlcmluZwpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpZMjAzOCBtYWlsaW5n
IGxpc3QKWTIwMzhAbGlzdHMubGluYXJvLm9yZwpodHRwczovL2xpc3RzLmxpbmFyby5vcmcvbWFp
bG1hbi9saXN0aW5mby95MjAzOAo=
