From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: TMSCSIM [2.6]
Date: Sun, 23 Nov 2003 21:26:02 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m365haomqt.fsf@merlin.emma.line.org>
References: <Pine.LNX.4.44.0311230024300.1354-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:34439 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S263460AbTKWU0E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Nov 2003 15:26:04 -0500
Received: from m2a2.dyndns.org (krusty.dt.e-technik.uni-dortmund.de [129.217.163.1])
	by mail.dt.e-technik.uni-dortmund.de (Postfix) with ESMTP id 9541315B2C
	for <linux-scsi@vger.kernel.org>; Sun, 23 Nov 2003 21:26:03 +0100 (CET)
In-Reply-To: <Pine.LNX.4.44.0311230024300.1354-100000@poirot.grange> (Guennadi
 Liakhovetski's message of "Sun, 23 Nov 2003 00:27:32 +0100 (CET)")
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> @@ -47,8 +47,9 @@
>      DC390_write8 (CtrlReg4, pDCB->CtrlR4);
>      DC390_write8 (ScsiCmd, CLEAR_FIFO_CMD);		/* Flush FIFO */
>      DEBUG1(printk (KERN_INFO "DC390: Start SCSI command: %02x (Sync:%02x)\n",\
> -	    pSRB->pcmd->cmnd[0], pDCB->SyncMode);)
> -    disc_allowed = pDCB->DevMode & EN_DISCONNECT_; try_sync_nego = 0;
> +	    pSRB->pcmd->cmnd[0], pDCB->SyncMode));
> +    disc_allowed = pDCB->DevMode & EN_DISCONNECT_;
> +    try_sync_nego = 0;
>      /* Don't disconnect on AUTO_REQSENSE, cause it might be an
>       * Contingent Allegiance Condition (6.6), where no tags should be used.
>       * All other have to be allowed to disconnect to prevent Incorrect

Out if interest: Why "try_sync_nego = 0"?

-- 
Matthias Andree

Encrypt your mail: my GnuPG key ID is 0x052E7D95
