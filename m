From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [PATCH 5/5] zfcp: convert zfcp to use target reset and device reset handler
Date: Sat, 1 Mar 2008 14:34:34 +0100
Message-ID: <20080301133433.GA5098@schmichrtp.de.ibm.com>
References: <1204331123-3833-1-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-2-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-3-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-4-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-5-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-6-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:7079 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbYCANej (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Mar 2008 08:34:39 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.13.8/8.13.8) with ESMTP id m21DYbP2176270
	for <linux-scsi@vger.kernel.org>; Sat, 1 Mar 2008 13:34:37 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m21DYa8e520326
	for <linux-scsi@vger.kernel.org>; Sat, 1 Mar 2008 14:34:36 +0100
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m21DYZ0L005769
	for <linux-scsi@vger.kernel.org>; Sat, 1 Mar 2008 14:34:36 +0100
Content-Disposition: inline
In-Reply-To: <1204331123-3833-6-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, james.smart@emulex.com, andrew.vasquez@qlogic.com, mp3@de.ibm.com, rmk@arm.linux.org.uk, matthew@wil.cx

On Fri, Feb 29, 2008 at 06:25:23PM -0600, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> zfcp uses the device reset handler to try and send a lun reset.
> If that fails it then does a target reset. This patch has it
> do a lun reset in the target reset handler like other drivers,
> then do a target reset in the target reset handler. scsi_error.c
> will escalate from device reset to target reset for the driver.
> 
> This patch is only compile tested since suprisingly I could find
> a s390 box, but I could not hook storage into the the zfcp adapter
> (box was remote).
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

Mike,

thank you very much for this work.  I will reply to the mail with a
adapted version of the patch: When we are implementing the target
reset handler in zfcp, we can remove the decision what to do from zfcp
and let the midlayer decide what should be reset.

--
Christof Schmitt
