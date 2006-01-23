From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/13] SCSI: export scsi_eh_finish_cmd() and scsi_eh_flush_done_q()
Date: Mon, 23 Jan 2006 09:36:12 +0000
Message-ID: <20060123093612.GA9157@infradead.org>
References: <11379891632102-git-send-email-htejun@gmail.com> <11379891632150-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55716 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932136AbWAWJgP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jan 2006 04:36:15 -0500
Content-Disposition: inline
In-Reply-To: <11379891632150-git-send-email-htejun@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: taejun@hotmail.com, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Mon, Jan 23, 2006 at 01:06:03PM +0900, Tejun Heo wrote:
> Export two SCSI EH command handling functions.  To be used by libata EH.

What do you need it for?  Please send the whole patch series (and generally
anything in libata that interacts with the scsi midlayer) to linux-scsi,
please.

