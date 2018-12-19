From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/41] scsi: Mark expected switch
 fall-throughs
Date: Tue, 18 Dec 2018 22:45:46 -0500
Message-ID: <yq1mup2i3h1.fsf@oracle.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <304623b0-e0ad-ec9c-7097-c6f00ba43948@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <xen-devel-bounces@lists.xenproject.org>
In-Reply-To: <304623b0-e0ad-ec9c-7097-c6f00ba43948@embeddedor.com> (Gustavo
 A. R. Silva's message of "Tue, 18 Dec 2018 09:23:54 -0600")
List-Unsubscribe: <https://lists.xenproject.org/mailman/options/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xenproject.org>
List-Help: <mailto:xen-devel-request@lists.xenproject.org?subject=help>
List-Subscribe: <https://lists.xenproject.org/mailman/listinfo/xen-devel>,
 <mailto:xen-devel-request@lists.xenproject.org?subject=subscribe>
Errors-To: xen-devel-bounces@lists.xenproject.org
Sender: "Xen-devel" <xen-devel-bounces@lists.xenproject.org>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Don Brace <don.brace@microsemi.com>, Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Matthew Wilcox <willy@infradead.org>, Vinayak Holikatti <vinholikatti@gmail.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, Kees Cook <keescook@chromium.org>, Hannes Reinecke <hare@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, Bradley Grove <linuxdrivers@attotech.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, Subbu Seetharaman <subbu.seetharaman@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, esc.storagedev@microsemi.com, James Smart <james.smart@broadcom.com>, Finn Thain <fthain@telegraphics.com.au>, Kashyap Desai <kashyap.desai@broadcom.com>, xen-devel@lists.xenproject.org, osst-users@lists.sourceforge.net, MPT-FusionLinux.pdl@broadcom.com, Boaz Harrosh <ooo@electrozaur.com>, Dick Kennedy <di>
List-Id: linux-scsi@vger.kernel.org

CkhpIEd1c3Rhdm8sCgo+IE9ubHkgOCBvdXQgdGhlIDQxIHBhdGNoZXMgaW4gdGhpcyBzZXJpZXMg
aGF2ZSBiZWVuIGFwcGxpZWQgc28gZmFyLgoKSSBhcHBsaWVkIHRoZSBwYXRjaGVzIHRoYXQgZ290
IGFja2VkIG9yIHJldmlld2VkIGJ5IHRoZWlyIHJlc3BlY3RpdmUKZHJpdmVyIG1haW50YWluZXJz
LgoKSWYgeW91IGhhdmVuJ3QgcmVjZWl2ZWQgZmVlZGJhY2sgb24gYSBwYXRjaCB5b3Ugc2hvdWxk
IHBva2UgdGhlIHJlbGV2YW50CmRyaXZlciBtYWludGFpbmVyLgoKLS0gCk1hcnRpbiBLLiBQZXRl
cnNlbglPcmFjbGUgTGludXggRW5naW5lZXJpbmcKCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fClhlbi1kZXZlbCBtYWlsaW5nIGxpc3QKWGVuLWRldmVsQGxp
c3RzLnhlbnByb2plY3Qub3JnCmh0dHBzOi8vbGlzdHMueGVucHJvamVjdC5vcmcvbWFpbG1hbi9s
aXN0aW5mby94ZW4tZGV2ZWw=
