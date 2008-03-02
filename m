From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] zfcp: convert zfcp to use target reset and device reset
 handler
Date: Sun, 02 Mar 2008 03:09:20 -0600
Message-ID: <47CA6EC0.7010606@cs.wisc.edu>
References: <1204331123-3833-1-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-2-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-3-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-4-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-5-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-6-git-send-email-michaelc@cs.wisc.edu> <20080301133632.GB5098@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47054 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbYCBJJw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Mar 2008 04:09:52 -0500
In-Reply-To: <20080301133632.GB5098@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, james.smart@emulex.com, andrew.vasquez@qlogic.com, mp3@de.ibm.com, rmk@arm.linux.org.uk, matthew@wil.cx

Christof Schmitt wrote:
> [based on proposal from Mike Christie <michaelc@cs.wisc.edu>, this
> patch adds some simplifications to the handler functions]
> 
> With the new target reset handler callback in the SCSI midlayer, the
> device reset handler in zfcp can be split in two parts. Now, zfcp does
> not have to track anymore whether the device supports LUN resets, so
> remove this flag and let the SCSI midlayer decide what to do.
> 
> The device reset handler simply issues a LUN reset and the target
> reset handler a target reset.
> 
> Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>

Thanks for the review and testing. Your patch looks better than mine.

Reviewed-by Mike Christie <michaelc@cs.wisc.edu>
