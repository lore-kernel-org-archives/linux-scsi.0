From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3] scsi: pmcraid: replace struct timeval with
	ktime_get_real_seconds()
Date: Wed, 11 Nov 2015 20:54:58 -0500
Message-ID: <yq1mvukt219.fsf@sermon.lab.mkp.net>
References: <1447097660-3063-1-git-send-email-amsfield22@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <1447097660-3063-1-git-send-email-amsfield22@gmail.com> (Alison
 Schofield's message of "Mon, 9 Nov 2015 11:34:20 -0800")
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
Cc: y2038@lists.linaro.org, outreachy-kernel@googlegroups.com, JBottomley@odin.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Pj4+Pj4gIkFsaXNvbiIgPT0gQWxpc29uIFNjaG9maWVsZCA8YW1zZmllbGQyMkBnbWFpbC5jb20+
IHdyaXRlczoKCkFsaXNvbj4gUmVwbGFjZSB0aGUgdXNlIG9mIHN0cnVjdCB0aW1ldmFsIGFuZCBk
b19nZXR0aW1lb2ZkYXkoKSB3aXRoIDY0CkFsaXNvbj4gYml0IGt0aW1lX2dldF9yZWFsX3NlY29u
ZHMuIFByZXZlbnRzIDMyLWJpdCB0eXBlIG92ZXJmbG93IGluCkFsaXNvbj4geWVhciAyMDM4IG9u
IDMyLWJpdCBzeXN0ZW1zLgoKQXBwbGllZC4KCi0tIApNYXJ0aW4gSy4gUGV0ZXJzZW4JT3JhY2xl
IExpbnV4IEVuZ2luZWVyaW5nCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fClkyMDM4IG1haWxpbmcgbGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3JnCmh0dHBz
Oi8vbGlzdHMubGluYXJvLm9yZy9tYWlsbWFuL2xpc3RpbmZvL3kyMDM4Cg==
