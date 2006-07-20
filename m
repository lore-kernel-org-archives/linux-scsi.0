From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Promise 'stex' driver
Date: Thu, 20 Jul 2006 19:55:28 -0400
Message-ID: <1153439728.4754.19.camel@mulgrave>
References: <NONAMEBMcvsq9IcVux1000001f9@nonameb.ptu.promise.com>
	 <44BFF539.4000700@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:45235 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030417AbWGTX4I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jul 2006 19:56:08 -0400
In-Reply-To: <44BFF539.4000700@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Ed Lin <ed.lin@promise.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, hch <hch@infradead.org>, linux-kernel <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>, promise_linux <promise_linux@promise.com>

On Thu, 2006-07-20 at 17:27 -0400, Jeff Garzik wrote:
> Since _no individual SCSI driver_ uses the block layer
> tagging, it is likely that some instability and core kernel
> development
> will occur, in order to make that work.

That's not quite true: 53c700 and tmscsim both use it ... I could with
the usage were wider, but at least 53c700 has pretty regular and
constant usage ... enough I think to validate the block tag code (it's
been using it for the last three years).

James


