From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Don't retry SG_IO (REQ_BLOCK_PC) commands.
Date: 21 Nov 2003 06:48:32 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069418912.1931.5.camel@mulgrave>
References: <20031120085555.A20609@beaverton.ibm.com>
	<20031120181543.GA3728@beaverton.ibm.com> <20031120191651.GE1106@suse.de>
	<20031120135123.A2366@beaverton.ibm.com>  <20031121101728.GI1106@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:20742 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262761AbTKUNsg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2003 08:48:36 -0500
In-Reply-To: <20031121101728.GI1106@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Patrick Mansfield <patmans@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2003-11-21 at 04:17, Jens Axboe wrote:
> On Thu, Nov 20 2003, Patrick Mansfield wrote:
> > Should the setting of REQ_FAILFAST be expanded to prevent requeueing after
> > a device or host reports queue full?
> 
> Not without extra hints.

So the code to add the hints is in the works?

;-)

James


