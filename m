From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Is there a grand plan for FC failover?
Date: 26 Jan 2004 09:37:25 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075131446.2290.29.camel@mulgrave>
References: <401521A7.5030808@thekelleys.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:5839 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263851AbUAZPh2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2004 10:37:28 -0500
In-Reply-To: <401521A7.5030808@thekelleys.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Simon Kelley <simon@thekelleys.org.uk>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-01-26 at 08:18, Simon Kelley wrote:
> I see that 2.6.x kernels now have the qla2xxx driver in the mainline, 
> but without the failover code.
> 
> What is the reason for that? Is there a plan provide failover facilities 
>   at a higher level which will be usable with all suitable low-level 
> drivers and hardware?
> 
> I'm very much in favour of using drivers which are developed in the 
> kernel mainline but I have an application which needs failover so I 
> might be forced back to the qlogic-distributed code.

Yes, the direction coming out of KS/OLS last year was to use the dm or
md multi-path code to sit the failover driver on top of sd (or any other
block driver).

The idea being that the Volume Manager layer is the most stack generic
place to do this type of thing.  The thread on this is here:

http://marc.theaimsgroup.com/?t=106005575400003

James


