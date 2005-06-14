From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/11]  qla2xxx: Add ISP24xx IOCB manipulation routines.
Date: Tue, 14 Jun 2005 22:50:41 +0100
Message-ID: <20050614215041.GD5849@infradead.org>
References: <20050614053136.12127.506.sendpatchset@plap.qlogic.com> <20050614053207.12127.3402.sendpatchset@plap.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:39379 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261362AbVFNVun (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2005 17:50:43 -0400
Content-Disposition: inline
In-Reply-To: <20050614053207.12127.3402.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

> + * @sp: command to send to the ISP
> + *
> + * Returns non-zero if a failure occured, else zero.
> + */
> +int
> +qla24xx_start_scsi(srb_t *sp)

It'd rather see 24xx having it's own ->queuecommand then adding another
dispatch layer slightly below it.  Put the code before and after _start_scsi
into nice helpers so it's shared.

