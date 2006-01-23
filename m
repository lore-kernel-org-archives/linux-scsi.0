From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 07/13] SCSI: export scsi_eh_finish_cmd() and scsi_eh_flush_done_q()
Date: Mon, 23 Jan 2006 09:19:53 -0500
Message-ID: <20060123141953.GA1648@havoc.gtf.org>
References: <11379891632102-git-send-email-htejun@gmail.com> <11379891632150-git-send-email-htejun@gmail.com> <20060123093612.GA9157@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:12267 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751375AbWAWOUC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jan 2006 09:20:02 -0500
Content-Disposition: inline
In-Reply-To: <20060123093612.GA9157@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Tejun Heo <htejun@gmail.com>, taejun@hotmail.com, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Mon, Jan 23, 2006 at 09:36:12AM +0000, Christoph Hellwig wrote:
> On Mon, Jan 23, 2006 at 01:06:03PM +0900, Tejun Heo wrote:
> > Export two SCSI EH command handling functions.  To be used by libata EH.
> 
> What do you need it for?  Please send the whole patch series (and generally
> anything in libata that interacts with the scsi midlayer) to linux-scsi,
> please.

It will replace the nasty and insufficient scsi_finish_command() export,
which doesn't retry like Tejun's current patches do.  Exporting these
two functions, and un-exporting scsi_finish_command(), is necessary for
users of ->eh_strategy_handler().

	Jeff



