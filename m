From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/10] sd: don't use scsi_setup_blk_pc_cmnd for discard
	requests
Date: Sun, 13 Jul 2014 16:56:22 +0200
Message-ID: <20140713145622.GA1831@lst.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de> <1404048881-19526-7-git-send-email-hch@lst.de> <yq14myl1g3q.fsf@sermon.lab.mkp.net> <53C29D45.8000301@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34918 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735AbaGMO4Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jul 2014 10:56:25 -0400
Content-Disposition: inline
In-Reply-To: <53C29D45.8000301@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Sun, Jul 13, 2014 at 10:52:53AM -0400, Douglas Gilbert wrote:
> To make things clearer when referring to the WRITE SAME command
> I would suggest "WRITE SAME(unmap)" for the case when its UNMAP
> field is 1 (as I assume it is in this case).

Actually it could be WRITE SAME (10) with or without unmap,
or WRITE SAME (16) with unmap.  So just leaving it without qualifier here
seems to be least confusing.

