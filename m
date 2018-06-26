From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: lpfc: use monotonic timestamps for
	statistics
Date: Tue, 26 Jun 2018 12:00:54 -0400
Message-ID: <yq1sh594jwp.fsf@oracle.com>
References: <20180618152903.1756535-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20180618152903.1756535-1-arnd@arndb.de> (Arnd Bergmann's message
 of "Mon, 18 Jun 2018 17:28:23 +0200")
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
Cc: Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, y2038@lists.linaro.org, James Smart <james.smart@broadcom.com>, linux-kernel@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Dick Kennedy <dick.kennedy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

CkFybmQsCgo+IFRoZSBnZXRfc2Vjb25kcygpIGZ1bmN0aW9uIHN1ZmZlcnMgZnJvbSBhIHBvc3Np
YmxlIG92ZXJmbG93IGluIDIwMzggb3IKPiAyMTA2LCBhcyB3ZWxsIGFzIGppdHRlciBkdWUgdG8g
c2V0dGltZW9mZGF5IG9yIGxlYXAgc2Vjb25kIHVwZGF0ZXMsCj4gYW5kIGlzIGRlcHJlY2F0ZWQu
Cj4KPiBBcyB3ZSBhcmUgaW50ZXJlc3RlZCBpbiBlbGFwc2VkIHRpbWUgb25seSwgdXNpbmcga3Rp
bWVfZ2V0X3NlY29uZHMoKQo+IHRvIHJlYWQgdGhlIENMT0NLX01PTk9UT05JQyB0aW1lYmFzZSBp
cyBpZGVhbCBoZXJlLiBUaGlzIGFsc28gbGV0cyB1cwo+IHJlbW92ZSB0aGUgaGFjayB0aGF0IHRy
aWVzIHRvIGRlYWwgd2l0aCBnZXRfc2Vjb25kcygpIGdvaW5nIHNsaWdodGx5Cj4gYmFja3dhcmRz
LCB3aGljaCBjYW5ub3QgaGFwcGVuIHdpdGggbW9udG9uaWMgdGltZXN0YW1wcy4KCkFwcGxpZWQg
dG8gNC4xOS9zY3NpLXF1ZXVlLiBUaGFua3MhCgotLSAKTWFydGluIEsuIFBldGVyc2VuCU9yYWNs
ZSBMaW51eCBFbmdpbmVlcmluZwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwpZMjAzOCBtYWlsaW5nIGxpc3QKWTIwMzhAbGlzdHMubGluYXJvLm9yZwpodHRw
czovL2xpc3RzLmxpbmFyby5vcmcvbWFpbG1hbi9saXN0aW5mby95MjAzOAo=
