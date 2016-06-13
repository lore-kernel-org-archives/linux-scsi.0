From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 1/3] Add bio/request flags for using ZBC/ZAC commands
Date: Mon, 13 Jun 2016 01:01:07 -0700
Message-ID: <20160613080107.GA26544@infradead.org>
References: <1465542626-26536-1-git-send-email-shaun@tancheff.com>
 <1465542833-26828-1-git-send-email-shaun@tancheff.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60466 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964889AbcFMIBL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2016 04:01:11 -0400
Content-Disposition: inline
In-Reply-To: <1465542833-26828-1-git-send-email-shaun@tancheff.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaun Tancheff <shaun@tancheff.com>
Cc: linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Shaun Tancheff <shaun.tancheff@seagate.com>

On Fri, Jun 10, 2016 at 02:13:53AM -0500, Shaun Tancheff wrote:
> T10 ZBC and T13 ZAC specify operations for Zoned devices.
> 
> To be able to access the zone information and open and close zones
> adding flags for the report zones command (REQ_REPORT_ZONES) and for
> Open and Close zone (REQ_OPEN_ZONE and REQ_CLOSE_ZONE) can be added
> for use by struct bio's bi_rw and by struct request's cmd_flags.

These need to be new operations, e.g. they should be in the REQ_OP_*
enum.  And please use a separate opcode for each actual operation.
