From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] Don't retry SG_IO (REQ_BLOCK_PC) commands.
Date: Thu, 20 Nov 2003 10:15:43 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031120181543.GA3728@beaverton.ibm.com>
References: <20031120085555.A20609@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:52415 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S262580AbTKTSLp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 13:11:45 -0500
Content-Disposition: inline
In-Reply-To: <20031120085555.A20609@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Pat LaVarre <p.lavarre@ieee.org>, dmitrik@users.sourceforge.net, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@suse.de>

Patrick Mansfield [patmans@us.ibm.com] wrote:
> Don't retry SG_IO (REQ_BLOCK_PC) commands.

Should we also have the REQ_BLOCK_PC requests set REQ_FAILFAST? The
patch to sd will imply the same behavior.

-andmike
--
Michael Anderson
andmike@us.ibm.com

