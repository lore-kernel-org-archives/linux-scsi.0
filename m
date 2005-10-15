From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/12]  qla2xxx: Use midlayer's int_to_scsilun() function.
Date: Sat, 15 Oct 2005 12:58:37 +0100
Message-ID: <20051015115837.GC24919@infradead.org>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com> <20051013231704.27191.38698.sendpatchset@plap.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:29851 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751133AbVJOL6p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Oct 2005 07:58:45 -0400
Content-Disposition: inline
In-Reply-To: <20051013231704.27191.38698.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

> -	cmd_pkt->lun[1] = LSB(sp->cmd->device->lun);
> -	cmd_pkt->lun[2] = MSB(sp->cmd->device->lun);
> +	int_to_scsilun(sp->cmd->device->lun, (struct scsi_lun *)cmd_pkt->lun);

Please make the field of type struct scsi_lun instead of the cast.

