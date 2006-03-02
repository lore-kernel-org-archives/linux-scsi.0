From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] SCSI sym53c8xx_2: bigger transfer limits
Date: Wed, 1 Mar 2006 20:57:45 -0700
Message-ID: <20060302035745.GF1598@parisc-linux.org>
References: <Pine.LNX.4.63.0602282104040.6272@kai.makisara.local> <20060301152929.GZ4816@suse.de> <Pine.LNX.4.63.0603012230370.5789@kai.makisara.local> <20060301204345.GP4816@suse.de> <Pine.LNX.4.63.0603020011500.5789@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:57284 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750769AbWCBD5r
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Mar 2006 22:57:47 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0603020011500.5789@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org

On Thu, Mar 02, 2006 at 12:24:27AM +0200, Kai Makisara wrote:
> > I'm just reporting what Gerald (who definitely knows this hardware very
> > well) told me, when I submitted a patch to him enabling clustering a
> > long time ago. This might have been about 5 years ago, I seem to recall
> > it happening when I used a un ultra10 workstation which had a sym scsi
> > board.
> > 
> A bit vague but I guess this is all we know. Unless Matthew knows more?

Alas, I don't know the hardware very well.  I try my hardest to fix
bugs and clean the driver up, but I'm no Gerard.  I do have the chip
documentation, but it's not exactly conducive to answering these kinds
of questions.  Also, the PDFs don't include the errata that Gerard
clearly had access to.
