From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Subject: Re: kernel BUG at drivers/scsi/scsi_lib.c:1096!
Date: Sat, 21 Nov 2015 12:30:14 +0100
Message-ID: <565055C6.5040801@linux.vnet.ibm.com>
References: <1447838334.1564.2.camel@ellerman.id.au>
 <1447855399.3974.24.camel@redhat.com>
 <1447894964.15206.0.camel@ellerman.id.au>
 <20151119082325.GA11419@infradead.org>
 <1448021448.14769.7.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1448021448.14769.7.camel@ellerman.id.au>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Michael Ellerman <mpe@ellerman.id.au>, Ming Lei <ming.lei@canonical.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, "James E. J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, brking <brking@us.ibm.com>, Mark Salter <msalter@redhat.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

T24gMjAvMTEvMjAxNSAxMzoxMCwgTWljaGFlbCBFbGxlcm1hbiB3cm90ZToKPiBPbiBUaHUsIDIw
MTUtMTEtMTkgYXQgMDA6MjMgLTA4MDAsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOgo+IAo+PiBJ
dCdzIHByZXR0eSBtdWNoIGd1YXJhbnRlZWQgYSBibG9jayBsYXllciBidWcsIG1vc3QgbGlrZWx5
IGluIHRoZQo+PiBtZXJnZSBiaW9zIHRvIHJlcXVlc3QgaW5mcmFzdHVjdHVyZSB3aGVyZSB3ZSBk
b24ndCBvYmV5IHRoZSBtZXJnaW5nCj4+IGxpbWl0cyBwcm9wZXJseS4KPj4KPj4gRG9lcyBlaXRo
ZXIgb2YgeW91IGhhdmUgYSBrbm93biBnb29kIGFuZCBmaXJzdCBrbm93biBiYWQga2VybmVsPwo+
IAo+IE5vdCBtZSwgSSd2ZSBvbmx5IGhpdCBpdCBvbmUgb3IgdHdvIHRpbWVzLiBBbGwgSSBjYW4g
c2F5IGlzIEkgaGF2ZSBoaXQgaXQgaW4KPiA0LjQtcmMxLgo+IAo+IExhdXJlbnQsIGNhbiB5b3Ug
bmFycm93IGl0IGRvd24gYXQgYWxsPwoKSXQgc2VlbXMgdGhhdCB0aGUgcGFuaWMgaXMgdHJpZ2dl
cmVkIGJ5IHRoZSBjb21taXQgYmRjZWQ0MzhhY2Q4ICgiYmxvY2s6CnNldHVwIGJpX3BoeXNfc2Vn
bWVudHMgYWZ0ZXIgc3BsaXR0aW5nIikgd2hpY2ggaGFzIGJlZW4gcHVsbGVkIGJ5IHRoZQptZXJn
ZSBkOTczNGUwZDFjY2YgKCJNZXJnZSBicmFuY2ggJ2Zvci00LjQvY29yZScgb2YKZ2l0Oi8vZ2l0
Lmtlcm5lbC5kay9saW51eC1ibG9jayIpLgoKTXkgc3lzdGVtIGlzIHBhbmljaW5nIHByb21wdGx5
IHdoZW4gcnVubmluZyBhIGtlcm5lbCBidWlsdCBhdApkOTczNGUwZDFjY2YsIHdoaWxlIHJldmVy
dGluZyB0aGUgY29tbWl0IGJkY2VkNDM4YWNkOCwgaXQgY2FuIHJ1biBob3Vycwp3aXRob3V0IHBh
bmljaW5nLgoKVGhpcyBiZWluZyBzYWlkLCBJIGNhbid0IGV4cGxhaW4gd2hhdCdzIGdvaW5nIHdy
b25nLgoKTWF5IE1pbmcgc2hlZCBzb21lIGxpZ2h0IGhlcmUgPwoKQ2hlZXJzCgoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXhwcGMtZGV2IG1haWxp
bmcgbGlzdApMaW51eHBwYy1kZXZAbGlzdHMub3psYWJzLm9yZwpodHRwczovL2xpc3RzLm96bGFi
cy5vcmcvbGlzdGluZm8vbGludXhwcGMtZGV2
