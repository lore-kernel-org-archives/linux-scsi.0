From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Reimplement the SG_FLAG_LUN_INHIBIT flag in sg's SG_IOCTL.
Date: Mon, 19 Dec 2005 17:20:15 +0000
Message-ID: <20051219172015.GA13438@infradead.org>
References: <20051216215447.GA25090@porkrind.org> <20051217122802.GA12725@infradead.org> <1265DA04D7476A91BFE5A61E@bluey.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:5800 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932199AbVLSRUQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Dec 2005 12:20:16 -0500
Content-Disposition: inline
In-Reply-To: <1265DA04D7476A91BFE5A61E@bluey.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Caldwell <david@porkrind.org>
Cc: linux-scsi@vger.kernel.org

On Sun, Dec 18, 2005 at 06:44:16PM -0800, David Caldwell wrote:
> >scsi_request is hopefully not going to survive 2.6.16 so at this point
> >this patch is not interesting in this form.
> 
> Have you started this work yet? I can re-implement the patch in the latest 
> code base if you can point me to it.

In James' scsi-misc tree the work is almost done.  All drivers but osst
and gdth are not using scsi_request anymore.  Any implementation that
support the block/scsi_ioctl.c and drivers/scsi/sg.c SG_IO implementations
in that tree should be fine with when scsi_request is finally gone.

