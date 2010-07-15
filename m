From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] driver core: remove CONFIG_SYSFS_DEPRECATED
Date: Thu, 15 Jul 2010 10:51:34 +0200
Message-ID: <AANLkTim0cri2RqpP7AadlGdw_U-JM81LE-g8BTnb05Ox@mail.gmail.com>
References: <20100709185450.GA29473@kroah.com>
	<20100714163852.b3c09930.akpm@linux-foundation.org>
	<20100715035230.GA2186@suse.de>
	<AANLkTilFLBpQR1BS8WFDXiLSOl08rI9DMpDhdkMXn1st@mail.gmail.com>
	<20100715013619.ba473d39.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <20100715013619.ba473d39.akpm@linux-foundation.org>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
	<mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
	<mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Sender: alsa-devel-bounces@alsa-project.org
Errors-To: alsa-devel-bounces@alsa-project.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Randy Dunlap <randy.dunlap@oracle.com>, alsa-devel@alsa-project.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-scsi@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Alan Stern <stern@rowland.harvard.edu>, "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Stephen Hemminger <shemminger@vyatta.com>, "David S. Miller" <davem@davemloft.net>
List-Id: linux-scsi@vger.kernel.org

T24gVGh1LCBKdWwgMTUsIDIwMTAgYXQgMTA6MzYsIEFuZHJldyBNb3J0b24gPGFrcG1AbGludXgt
Zm91bmRhdGlvbi5vcmc+IHdyb3RlOgo+IE9uIFRodSwgMTUgSnVsIDIwMTAgMTA6MzE6MTUgKzAy
MDAgS2F5IFNpZXZlcnMgPGtheS5zaWV2ZXJzQHZyZnkub3JnPiB3cm90ZToKPgo+PiBPbiBUaHUs
IEp1bCAxNSwgMjAxMCBhdCAwNTo1MiwgR3JlZyBLSCA8Z3JlZ2toQHN1c2UuZGU+IHdyb3RlOgo+
PiA+IE9uIFdlZCwgSnVsIDE0LCAyMDEwIGF0IDA0OjM4OjUyUE0gLTA3MDAsIEFuZHJldyBNb3J0
b24gd3JvdGU6Cj4+Cj4+ID4+IGFuZCB0aGUgYm94IHN0aWxsIHdvbid0IGJvb3QuCj4+ID4KPj4g
PiBJY2ssIHRoYXQgc3Vja3MuCj4+ID4KPj4gPiBXaGF0IGtlcm5lbCB3YXMgRkM2IGJhc2VkIG9u
IG9yaWdpbmFsbHk/Cj4+ID4KPj4gPiBLYXksIEkgdGhvdWdodCB0aGF0IEZlZG9yYSBoYWQgZml4
ZWQgdGhlICJjYW4ndCBmaW5kIHJvb3QiIGlzc3VlIGZvcgo+PiA+IHRoaXMgdHlwZSBvZiBzeXNm
cyBjb25maWd1YXRpb24gYSBsb25nIHRpbWUgYWdvLiBfX09yIHdhcyB0aGF0IHNvbWV0aGluZwo+
PiA+IGVsc2UgZm9yIFBQQyB0aGF0IEkgYW0gdGhpbmtpbmcgb2Y/Cj4+Cj4+IEl0IHdhcyBmaXhl
ZCwgYW5kIGl0J3Mgd2VpcmQgYnVnIGluIG5hc2guCj4+Cj4+IElmIEFuZHJldyBpcyBzdGlsbCBk
b2luZyB0aGUgc2FtZSB0aGluZyBhcyB5ZWFycyBhZ28sIGhlIGRvZXMgbm90Cj4+IHVwZGF0ZSB0
aGUgaW5pdHJhbWZzIGltYWdlLCBoZSBib290cyB3aXRoIHRoZSBvbGQgb3JpZ2luYWwgaW5pdHJh
bWZzCj4+IGFsb25nIHdpdGggdGhlIG5ldyBrZXJuZWwuIDopCj4KPiBJIHJ1bgo+Cj4gwqAgwqAg
wqAgwqBWRVJTPSQobWFrZSBrZXJuZWxyZWxlYXNlIDI+L2Rldi9udWxsKQo+IMKgIMKgIMKgIMKg
PGNvcHkgdm1saW51eD4KPiDCoCDCoCDCoCDCoC9zYmluL25ldy1rZXJuZWwtcGtnIC0tbWtpbml0
cmQgLS1pbnN0YWxsCgpBaCwgSSBzZWUuCgpJdCBtaWdodCBiZSwgdGhhdCB0aGUgZml4IG9ubHkg
aGl0IEZDNywgb3IgQW5kcmV3IGRpZCBub3QgaW5zdGFsbCB0aGUKdXBkYXRlcy4gVGhlIG9yaWdp
bmFsIG1haWwgYWJvdXQgdGhlIG5hc2ggcHJvYmxlbSBpcyBoZXJlOgogIGh0dHA6Ly9sa21sLm9y
Zy9sa21sLzIwMDcvNi83LzIwOQoKS2F5Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCkFsc2EtZGV2ZWwgbWFpbGluZyBsaXN0CkFsc2EtZGV2ZWxAYWxzYS1w
cm9qZWN0Lm9yZwpodHRwOi8vbWFpbG1hbi5hbHNhLXByb2plY3Qub3JnL21haWxtYW4vbGlzdGlu
Zm8vYWxzYS1kZXZlbAo=
