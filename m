From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] Don't retry SG_IO (REQ_BLOCK_PC) commands.
Date: Fri, 21 Nov 2003 19:23:01 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031121182301.GB6616@suse.de>
References: <20031120085555.A20609@beaverton.ibm.com> <20031120181543.GA3728@beaverton.ibm.com> <20031120191651.GE1106@suse.de> <20031120135123.A2366@beaverton.ibm.com> <20031121101728.GI1106@suse.de> <1069418912.1931.5.camel@mulgrave> <20031121082651.A8065@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:54678 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S264399AbTKUSXK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2003 13:23:10 -0500
Content-Disposition: inline
In-Reply-To: <20031121082651.A8065@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Nov 21 2003, Patrick Mansfield wrote:
> James -
> 
> I don't think we are going to resolve the setting and use of the fast fail
> flag in the immediate future.
> 
> Can you push the patch?

Agree, can't be done these days at all. Maybe in a months time or so.

> Jens are you OK with the patch?

Yes

-- 
Jens Axboe

