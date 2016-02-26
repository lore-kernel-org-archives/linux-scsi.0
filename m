From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND PATCH v2] scsi: gdth: replace struct timeval
	with ktime_get_real_seconds()
Date: Thu, 25 Feb 2016 21:17:35 -0500
Message-ID: <yq1fuwggqps.fsf@sermon.lab.mkp.net>
References: <20151119214304.GA16713@d830.WORKGROUP>
 <1455773374-2863-1-git-send-email-amsfield22@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <1455773374-2863-1-git-send-email-amsfield22@gmail.com> (Alison
 Schofield's message of "Wed, 17 Feb 2016 21:29:34 -0800")
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Alison Schofield <amsfield22@gmail.com>
Cc: y2038@lists.linaro.org, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, achim_leubner@pmc-sierra.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Pj4+Pj4gIkFsaXNvbiIgPT0gQWxpc29uIFNjaG9maWVsZCA8YW1zZmllbGQyMkBnbWFpbC5jb20+
IHdyaXRlczoKCkFsaXNvbj4gc3RydWN0IHRpbWV2YWwgd2lsbCBvdmVyZmxvdyBvbiAzMi1iaXQg
c3lzdGVtcyBpbiB5MjAzOCBhbmQgaXMKQWxpc29uPiBiZWluZyByZW1vdmVkIGZyb20gdGhlIGtl
cm5lbC4gUmVwbGFjZSB0aGUgdXNlIG9mIHN0cnVjdCB0aW1ldmFsCkFsaXNvbj4gYW5kIGRvX2dl
dHRpbWVvZmRheSgpIHdpdGgga3RpbWVfZ2V0X3JlYWxfc2Vjb25kcygpIHdoaWNoCkFsaXNvbj4g
cHJvdmlkZXMgYSA2NC1iaXQgc2Vjb25kcyB2YWx1ZSBhbmQgaXMgeTIwMzggc2FmZS4KCkFwcGxp
ZWQgdG8gNC42L3Njc2ktcXVldWUuCgotLSAKTWFydGluIEsuIFBldGVyc2VuCU9yYWNsZSBMaW51
eCBFbmdpbmVlcmluZwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwpZMjAzOCBtYWlsaW5nIGxpc3QKWTIwMzhAbGlzdHMubGluYXJvLm9yZwpodHRwczovL2xp
c3RzLmxpbmFyby5vcmcvbWFpbG1hbi9saXN0aW5mby95MjAzOAo=
