From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH v3] fusion: remove dead MTRR code
Date: Sat, 6 Jun 2015 00:11:17 +0200
Message-ID: <20150605221117.GR23057@wotan.suse.de>
References: <1429649166-18294-1-git-send-email-mcgrof@do-not-panic.com>
 <CAK=zhgqU7+Dm1ZUhVpGF_QMPAPnnaSbdh18GLajDvJBAXrGCQg@mail.gmail.com>
 <20150604174134.GQ23057@wotan.suse.de>
 <CAK=zhgqM3YM45=jYvhJkmFC-9TFBXDaeGXq1gcjERbFjmTxWVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49803 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbbFEWLV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Jun 2015 18:11:21 -0400
Content-Disposition: inline
In-Reply-To: <CAK=zhgqM3YM45=jYvhJkmFC-9TFBXDaeGXq1gcjERbFjmTxWVg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <JBottomley@parallels.com>, "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>, Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>, Andy Lutomirski <luto@amacapital.net>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, mst@redhat.com, Toshi Kani <toshi.kani@hp.com>, Suresh Siddha <sbsiddha@gmail.com>, Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>, Juergen Gross <jgross@suse.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@redhat.com>, Antonino Daplas <adaplas@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, Jun 05, 2015 at 05:17:08PM +0530, Sreekanth Reddy wrote:
> On Thu, Jun 4, 2015 at 11:11 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> > On Thu, Jun 04, 2015 at 10:20:23AM +0530, Sreekanth Reddy wrote:
> >> Hi Luis,
> >>
> >> Sorry for delay in response. Actually I was looking for the history of
> >> this section of code but I couldn't find it. Anyway this is dead code
> >> and we are fine with removing this dead code.
> >>
> >> James,
> >>
> >> Please consider this patch as:
> >>
> >> Acked-by: Sreekanth Reddy <ureekanth.reddy@avagotech.com>
> >
> > Great thanks, now who's tree should this patch go through? Last patch for this
> > driver was in 2014 and went through Christoph, but if Christoph doesn't want to
> > take it can it go through Andrew's tree?
> >
> > Sreekanth, can you also update the MAINTAINERS file to reflect recent changes
> > at your company ?
> 
> Sure I will do this.

Christoph, do you mind this going through Andrew's tree? Or do you want to take it?

  Luis
