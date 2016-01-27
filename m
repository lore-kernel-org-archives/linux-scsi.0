From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH,
	RESEND 3] qla2xxx: Remove use of 'struct timeval'
Date: Tue, 26 Jan 2016 21:14:35 -0500
Message-ID: <yq17fivix9w.fsf@sermon.lab.mkp.net>
References: <3640852.TIcaPixAiA@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <3640852.TIcaPixAiA@wuerfel> (Arnd Bergmann's message of "Mon, 25
 Jan 2016 23:00:20 +0100")
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
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, y2038@lists.linaro.org, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, Tina Ruchandani <ruchandani.tina@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Pj4+Pj4gIkFybmQiID09IEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+IHdyaXRlczoKCkFy
bmQ+IHN0cnVjdCByZWdpc3Rlcl9ob3N0X2luZm8gc3RvcmVzIGEgNjQtYml0IFVUQyBzeXN0ZW0g
dGltZQpBcm5kPiB0aW1lc3RhbXAuICBUaGlzIHBhdGNoIHJlbW92ZXMgdGhlIHVzZSBvZiAnc3Ry
dWN0IHRpbWV2YWwnIHRvCkFybmQ+IG9idGFpbiB0aGF0IHRpbWVzdGFtcCBhcyBpdHMgdHZfc2Vj
IHZhbHVlIHdpbGwgb3ZlcmZsb3cgb24gMzItYml0CkFybmQ+IHN5c3RlbXMgaW4geWVhciAyMDM4
IGJleW9uZC4gIFRoZSBwYXRjaCB1c2VzCkFybmQ+IGt0aW1lX2dldF9yZWFsX3NlY29uZHMoKSB3
aGljaCByZXR1cm5zIGEgNjQtYml0IHNlY29uZHMgdmFsdWUuCgpBcHBsaWVkIHRvIDQuNi9zY3Np
LXF1ZXVlLgoKLS0gCk1hcnRpbiBLLiBQZXRlcnNlbglPcmFjbGUgTGludXggRW5naW5lZXJpbmcK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWTIwMzggbWFp
bGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6Ly9saXN0cy5saW5hcm8ub3Jn
L21haWxtYW4vbGlzdGluZm8veTIwMzgK
