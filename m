From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: TMSCSIM [2.6]
Date: Sun, 23 Nov 2003 21:53:02 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311232151110.2286-100000@poirot.grange>
References: <m365haomqt.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:36788 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263462AbTKWUxH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Nov 2003 15:53:07 -0500
In-Reply-To: <m365haomqt.fsf@merlin.emma.line.org>
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Cc: linux-scsi@vger.kernel.org

On Sun, 23 Nov 2003, Matthias Andree wrote:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
>
> > @@ -47,8 +47,9 @@
> >      DC390_write8 (CtrlReg4, pDCB->CtrlR4);
> >      DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);		/* Flush FIFO */
> >      DEBUG1(printk (KERN_INFO "DC390: Start SCSI command: %02x (Sync:%02x)\n",\
> > -	    pSRB->pcmd->cmnd[0], pDCB->SyncMode);)
> > -    disc_allowed = pDCB->DevMode & EN_DISCONNECT_; try_sync_nego = 0;
> > +	    pSRB->pcmd->cmnd[0], pDCB->SyncMode));
> > +    disc_allowed = pDCB->DevMode & EN_DISCONNECT_;
> > +    try_sync_nego = 0;
> >      /* Don't disconnect on AUTO_REQSENSE, cause it might be an
> >       * Contingent Allegiance Condition (6.6), where no tags should be used.
> >       * All other have to be allowed to disconnect to prevent Incorrect
>
> Out if interest: Why "try_sync_nego = 0"?

No idea. I didn't change it - just broke the line. Actually, such
changes shouldn't go into patches, but it goes almost automatic, you
know:-(

Guennadi
---
Guennadi Liakhovetski


