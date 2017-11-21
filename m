From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/7] scsi: bfa: do_gettimeofday removal
Date: Mon, 20 Nov 2017 22:04:48 -0500
Message-ID: <yq11sksnxgv.fsf@oracle.com>
References: <20171110153715.1929456-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20171110153715.1929456-1-arnd@arndb.de> (Arnd Bergmann's message
 of "Fri, 10 Nov 2017 16:37:08 +0100")
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
Cc: hare@suse.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, y2038@lists.linaro.org, jthumshirn@suse.de, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

CkFybmQsCgo+IFRoZSBiZmEgZHJpdmVyIGlzIG9uZSBvZiB0aGUgbWFpbiB1c2VycyBvZiBkb19n
ZXR0aW1lb2ZkYXkoKSwgYQo+IGZ1bmN0aW9uIHRoYXQgSSdtIHRyeWluZyB0byByZW1vdmUgYXMg
cGFydCBvZiB0aGUgeTIwMzggY2xlYW51cC4KPgo+IFRoZSB0aW1lc3RhbXBzIGFyZSBhbGwgdXNl
cyBpbiBzbGlnaHRseSBkaWZmZXJlbnQgd2F5cywgc28gdGhpcyBoYXMKPiB0dXJuZWQgaW50byBh
IHJhdGhlciBsb25naXNoIHNlcmllcyBmb3IgZG9pbmcgc29tZXRoaW5nIHRoYXQgc2hvdWxkIGJl
Cj4gc2ltcGxlLgo+Cj4gVGhlIGxhc3QgcGF0Y2ggaW4gdGhlIHNlcmllcyAoInNjc2k6IGJmYTog
dXNlIDY0LWJpdCB0aW1lcyBpbgo+IGJmYV9hZW5fZW50cnlfcyBBQkkiKSBpcyBvbmUgdGhhdCBu
ZWVkcyB0byBiZSByZXZpZXdlZCB2ZXJ5IGNhcmVmdWxseSwKPiBhbmQgaXQgY2FuIGJlIHNraXBw
ZWQgaWYgdGhlIG1haW50YWluZXJzIHByZWZlciB0byBsZWF2ZSB0aGUgMzItYml0Cj4gQUJJIHVu
Y2hhbmdlZCwgdGhlIHJlc3QgYXJlIGhvcGVmdWxseSBmYWlybHkgc3RyYWlnaHRmb3J3YXJkLgoK
QXBwbGllZCB0byA0LjE2L3Njc2ktcXVldWUsIHRoYW5rcyEKCldpbGwgZHJvcCAjNyBpZiBzb21l
dGhpbmcgYnJlYWtzLgoKLS0gCk1hcnRpbiBLLiBQZXRlcnNlbglPcmFjbGUgTGludXggRW5naW5l
ZXJpbmcKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWTIw
MzggbWFpbGluZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6Ly9saXN0cy5saW5h
cm8ub3JnL21haWxtYW4vbGlzdGluZm8veTIwMzgK
