From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] convert eata to pass pointers around
Date: Tue, 2 Nov 2004 16:07:57 +0100
Message-ID: <20041102150757.GA32497@lst.de>
References: <20041102143351.GA32020@lst.de> <20041102145418.GA24690@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:9671 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261253AbUKBPH7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2004 10:07:59 -0500
Content-Disposition: inline
In-Reply-To: <20041102145418.GA24690@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Tue, Nov 02, 2004 at 02:54:18PM +0000, Matthew Wilcox wrote:
> On Tue, Nov 02, 2004 at 03:33:51PM +0100, Christoph Hellwig wrote:
> > @@ -836,7 +836,7 @@
> >  	struct mssp sp;		/* Local copy of sp buffer */
> >  };
> >  
> > -static struct Scsi_Host *sh[MAX_BOARDS + 1];
> > +struct Scsi_Host *sh[MAX_BOARDS];
> >  static const char *driver_name = "EATA";
> >  static char sha[MAX_BOARDS];
> >  static spinlock_t driver_lock = SPIN_LOCK_UNLOCKED;
> 
> Did you mean to un-static 'sh'?  This seems like an awfully vague
> name to make kernel-global ...

no.  but it'll be gone completely in one of the next patches.

