From: Tejun Heo <tj@kernel.org>
Subject: Re: [regression] 2.6.37-rc5: scsi_eh_11 CPU loop
Date: Tue, 21 Dec 2010 12:03:56 +0100
Message-ID: <20101221110355.GA981@htj.dyndns.org>
References: <201012201105.08993.Martin@lichtvoll.de>
 <4D0F8E98.9070500@kernel.org>
 <201012211131.27698.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201012211131.27698.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Tue, Dec 21, 2010 at 11:31:15AM +0100, Martin Steigerwald wrote:
> > diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> > index 5e59050..c748b5a 100644
> [...]
> > 
> > +	if (!(ap->pflags & ATA_PFLAG_LOADING) && xxx < 16) {
> > +		ata_port_printk(ap, KERN_WARNING, "XXX ata_eh_set_pending()\n");
> > +		dump_stack();
> > +		xxx++;
> > +	}
> > +
> 
> I will do so with my next kernel compile - likely rc7 if it comes out 
> before Christmas.
> 
> As I do not know what exactly triggers it, it can take a while till I 
> experience it again. I hope to be able to trigger it by inserting and 
> removing the PCMCIA eSATA adapter lots of times. As the bug happened, I 
> forgot to vgchange -an the LVM on the external drive. That might be or 
> might not be related to triggering the issue. I will try this as well.
> 
> Reported-as: https://bugzilla.kernel.org/show_bug.cgi?id=25392
> 
> Might make sense to switch this bugzilla report to mail. Or use the 
> bugzilla. Or just use the bugzilla for tracking and continue using mail. 
> I'll do whatever suits you best (but prefer mail).

I don't care either way.  Just ping me whenever you hit the problem
again.

Thanks.

-- 
tejun
