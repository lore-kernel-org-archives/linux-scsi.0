From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH v3] fusion: remove dead MTRR code
Date: Tue, 19 May 2015 22:27:32 +0200
Message-ID: <20150519202732.GN23057@wotan.suse.de>
References: <1429649166-18294-1-git-send-email-mcgrof@do-not-panic.com>
 <CAB=NE6V8bVPofvcaGhUebqZckvEAvbYrSdv1EJU52M-4vrFQ8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAB=NE6V8bVPofvcaGhUebqZckvEAvbYrSdv1EJU52M-4vrFQ8g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, "mpt-fusionlinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>, Linux SCSI List <linux-scsi@vger.kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, "Michael S. Tsirkin" <mst@redhat.com>, Toshi Kani <toshi.kani@hp.com>, Christoph Hellwig <hch@infradead.org>, Suresh Siddha <sbsiddha@gmail.com>, Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>, Juergen Gross <jgross@suse.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@redhat.com>, Antonino Daplas <adaplas@gmail.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>, Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Borislav Petkov <bp@suse.de>, Davidlohr Bueso <dbueso@suse.de>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 29, 2015 at 12:50:40PM -0700, Luis R. Rodriguez wrote:
> On Tue, Apr 21, 2015 at 1:46 PM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> >
> > If and when this gets enabled the driver could should split
> > up IO memory space properly and that is quite a bit of work.
> > Just remove the uncommented dead MTRR code then.
> >
> > There are a few motivations for this:
> >
> > a) Take advantage of PAT when available
> >
> > b) Help bury MTRR code away, MTRR is architecture specific and on
> >    x86 its replaced by PAT
> >
> > c) Help with the goal of eventually using _PAGE_CACHE_UC over
> >    _PAGE_CACHE_UC_MINUS on x86 on ioremap_nocache() (see commit
> >    de33c442e titled "x86 PAT: fix performance drop for glx,
> >    use UC minus for ioremap(), ioremap_nocache() and
> >    pci_mmap_page_range()")
> 
> Hey folks, who's tree should this go through if agreeable?

Hey folks, can this be applied? Thanks.

 Luis
