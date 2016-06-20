From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] scsi: libfc: fix seconds_since_last_reset
	calculation
Date: Mon, 20 Jun 2016 15:54:06 +0200
Message-ID: <76a47d73-26e2-5a9f-7a03-21c72ca613ca@sandisk.com>
References: <20160617154737.633440-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20160617154737.633440-1-arnd@arndb.de>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
To: Arnd Bergmann <arnd@arndb.de>, Vasu Dev <vasu.dev@intel.com>, "James E.J.
 Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: y2038@lists.linaro.org, fcoe-devel@open-fcoe.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

T24gMDYvMTcvMjAxNiAwNTo0NyBQTSwgQXJuZCBCZXJnbWFubiB3cm90ZToKPiAtCWppZmZpZXNf
dG9fdGltZXNwZWMoamlmZmllcywgJnYwKTsKPiAtCWppZmZpZXNfdG9fdGltZXNwZWMobHBvcnQt
PmJvb3RfdGltZSwgJnYxKTsKPiAtCWZjX3N0YXRzLT5zZWNvbmRzX3NpbmNlX2xhc3RfcmVzZXQg
PSAodjAudHZfc2VjIC0gdjEudHZfc2VjKTsKPiArCWZjX3N0YXRzLT5zZWNvbmRzX3NpbmNlX2xh
c3RfcmVzZXQgPSAobHBvcnQtPmJvb3RfdGltZSAtIGppZmZpZXMpIC8gSFo7CgpEb2VzIHRoaXMg
cGF0Y2ggaW50cm9kdWNlIGEgNjQtYml0IGRpdmlzaW9uPyBUaGVyZSBtaWdodCBzdGlsbCBiZSAz
Mi1iaXQgCnVzZXJzIG9mIHRoaXMgY29kZS4KCkJhcnQuCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fClkyMDM4IG1haWxpbmcgbGlzdApZMjAzOEBsaXN0cy5s
aW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGluYXJvLm9yZy9tYWlsbWFuL2xpc3RpbmZvL3kyMDM4
Cg==
