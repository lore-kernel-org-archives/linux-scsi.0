From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] [v2] aha152x cmnd->device oops
Date: 29 Oct 2003 12:10:17 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067451264.1829.37.camel@mulgrave>
References: <20031027155713.GA28140@lst.de>
	<20031027160101.76d5291b.rddunlap@osdl.org> <20031028090600.GA7370@lst.de>
	<20031028124536.3ce82c23.rddunlap@osdl.org> <3F9EF2B4.9030708@us.ibm.com>
	<20031028162610.6dcfd06e.rddunlap@osdl.org>
	<20031029122008.GA5903@linux-buechse.de> <1067439510.1829.4.camel@mulgrave>
	 <20031029175621.GB5903@linux-buechse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:47367 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261152AbTJ2SOd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 13:14:33 -0500
In-Reply-To: <20031029175621.GB5903@linux-buechse.de>
List-Id: linux-scsi@vger.kernel.org
To: "Juergen E. Fischer" <fischer@linux-buechse.de>
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, fischer@norbit.de

On Wed, 2003-10-29 at 11:56, Juergen E. Fischer wrote:
> Why not?  It's a new command after all and if the initialization is
> done correctly (ie. ->device is setup) it works the way it is now.

The usual reason is that ACA emulation is turned around in interrupt
context, so new memory allocations should be avoided if they can be.

for the aha that could eliminate the check for NULL cmnd.

James


