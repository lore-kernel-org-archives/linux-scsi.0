From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] qla2xxx: fix bad locking during eh_abort
Date: Fri, 27 May 2005 16:31:29 -0400
Message-ID: <1117225889.7379.25.camel@mulgrave>
References: <20050526231938.GA31205@plap.qlogic.org>
	 <1117224371.7379.21.camel@mulgrave>
	 <20050527201831.GE16474@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:30639 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262576AbVE0Ubo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 16:31:44 -0400
In-Reply-To: <20050527201831.GE16474@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-05-27 at 13:18 -0700, Andrew Vasquez wrote:
> Yes, with the latest changes being proposed/implemented by Jeff G.,
> there would need to be some additional massaging of the driver's
> eh_*() routines.
> 
> Are you planning on putting the host_lock-free changes in for -rc,
> I figured that would be going into the next kernel rev.  I mention
> that because I have a block of patches which I have queued-up to add
> new chip support to the driver.

No ... we're too close to a real kernel to put something like that in.
I'm just doing minimal essential bug fixes at the moment.

James


