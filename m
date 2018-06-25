From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi_transport_fc: use 64-bit timestamps
	consistently
Date: Mon, 25 Jun 2018 12:30:13 -0700
Message-ID: <3161ed3e-1237-6e80-2f3a-79cb8179a417@linux.vnet.ibm.com>
References: <20180618153004.1808419-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20180618153004.1808419-1-arnd@arndb.de>
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
To: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, y2038@lists.linaro.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

T24gMDYvMTgvMjAxOCAwODoyOSBBTSwgQXJuZCBCZXJnbWFubiB3cm90ZToKPiBUaGUgZ2V0X3Nl
Y29uZHMoKSBoZWxwZXIgcmV0dXJucyBhbiAndW5zaWduZWQgbG9uZycgdmFsdWUsIHdoaWNoIGNh
bgo+IG92ZXJmbG93IG9uIDMyLWJpdCBhcmNoaXRlY3R1cmVzLiBTaW5jZSB0aGUgaW50ZXJmYWNl
IHdlIHBhc3MgaXQgaW50bwo+IGFscmVhZHkgdXNlcyBhIDY0LWJpdCB0eXBlLCB3ZSBjYW4ganVz
dCB1c2Uga3RpbWVfZ2V0X3JlYWxfc2Vjb25kcygpCj4gaW5zdGVhZC4KPiAKPiBXaGlsZSB3ZSBn
ZW5lcmFsbHkgcHJlZmVyIGxvY2FsIHRpbWVzdGFtcHMgaW4gQ0xPQ0tfTU9OT1RPTklDIGZvcm1h
dAo+IChrdGltZV9nZXRfc2Vjb25kcyksIHRoaXMga2VlcHMgdXNpbmcgdGhlIENMT0NLX1JFQUxU
SU1FIHZlcnNpb24KPiBpbiBvcmRlciB0byBtYWludGFpbiBjb21wYXRpYmlsaXR5IHdpdGggZXhp
c3RpbmcgY29kZS4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRi
LmRlPgo+IC0tLQoKUmV2aWV3ZWQtYnk6IFR5cmVsIERhdHd5bGVyIDx0eXJlbGRAbGludXgudm5l
dC5pYm0uY29tPgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KWTIwMzggbWFpbGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6Ly9saXN0
cy5saW5hcm8ub3JnL21haWxtYW4vbGlzdGluZm8veTIwMzgK
