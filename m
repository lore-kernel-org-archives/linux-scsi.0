From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] Don't retry SG_IO (REQ_BLOCK_PC) commands.
Date: Thu, 20 Nov 2003 20:16:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031120191651.GE1106@suse.de>
References: <20031120085555.A20609@beaverton.ibm.com> <20031120181543.GA3728@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:56759 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263060AbTKTTSP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 14:18:15 -0500
Content-Disposition: inline
In-Reply-To: <20031120181543.GA3728@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>, Pat LaVarre <p.lavarre@ieee.org>, dmitrik@users.sourceforge.net, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Thu, Nov 20 2003, Mike Anderson wrote:
> Patrick Mansfield [patmans@us.ibm.com] wrote:
> > Don't retry SG_IO (REQ_BLOCK_PC) commands.
> 
> Should we also have the REQ_BLOCK_PC requests set REQ_FAILFAST? The
> patch to sd will imply the same behavior.

Definitely!

-- 
Jens Axboe

