From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] streamline block SG_IO error processing
Date: Thu, 20 Jan 2005 11:14:36 +0000
Message-ID: <20050120111436.GC32550@infradead.org>
References: <41E88FB5.7070001@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:22442 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262118AbVATLOh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2005 06:14:37 -0500
Content-Disposition: inline
In-Reply-To: <41E88FB5.7070001@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James.Bottomley@SteelEye.com

On Sat, Jan 15, 2005 at 01:36:21PM +1000, Douglas Gilbert wrote:
> Changelog:
>   - sd_init_command(): use retry count of 1 for block
>     SG_IO; minor cleanup
>   - sd_rw_init(): bypass sd level error processing for
>     block SG_IO
> 
> Signed-off-by: Douglas Gilbert <dougg@torque.net>

+	if (! blk_fs_request(rq))

same tiny nitpick as with the patch before

Else the patch looks great aswell, thanks Doug.
