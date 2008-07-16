From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] SCSI: erase invalid data returned by device
Date: Wed, 16 Jul 2008 16:39:39 +0200
Message-ID: <87lk0151w4.fsf@denkblock.local>
References: <87prpd5356.fsf@denkblock.local>
	<Pine.LNX.4.44L0.0807161026340.2322-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:48197 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415AbYGPOjv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2008 10:39:51 -0400
In-Reply-To: <Pine.LNX.4.44L0.0807161026340.2322-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Wed, 16 Jul 2008 10:28:12 -0400 (EDT)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Peter Teoh <htmldeveloper@gmail.com>, Maciej Rutecki <maciej.rutecki@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 16 Jul 2008, Elias Oltmanns wrote:
>
>> Oh, I see. The name fooled me there, I suppose. So, the meaning of
>> req->data_len is inverted, as it were, when the LLDD performs the data
>> transfer, right?
>
> The inversion takes place in the midlayer, not in the LLDD.  Take a
> look inside scsi_io_completion():
>
> 	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
> 		...
> 		req->data_len = scsi_get_resid(cmd);
> 	}

Right, thanks for the hint.

Regards,

Elias
