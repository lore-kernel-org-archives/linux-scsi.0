From: Andrew Vasquez <praka@san.rr.com>
Subject: Re: [PATCH] scsi_host sysfs updates scsi-misc-2.5 [0/2]
Date: Mon, 12 May 2003 08:15:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030512151553.GA22417@praka.local.home>
References: <20030509063321.GA3259@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orngca-mls02.socal.rr.com ([66.75.160.17]:40694 "EHLO
	orngca-mls02.socal.rr.com") by vger.kernel.org with ESMTP
	id S262206AbTELPGd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2003 11:06:33 -0400
Received: from san.rr.com (66-75-128-22.san.rr.com [66.75.128.22])
	by orngca-mls02.socal.rr.com (8.11.4/8.11.3) with ESMTP id h4CFGDL10040
	for <linux-scsi@vger.kernel.org>; Mon, 12 May 2003 08:16:13 -0700 (PDT)
Received: from san.rr.com (localhost [127.0.0.1])
	by san.rr.com (8.12.3/8.12.3/SuSE Linux 0.6) with ESMTP id h4CFFrjW022452
	for <linux-scsi@vger.kernel.org>; Mon, 12 May 2003 08:15:53 -0700
Received: (from praka@localhost)
	by san.rr.com (8.12.3/8.12.3/Submit) id h4CFFr85022451
	for linux-scsi@vger.kernel.org; Mon, 12 May 2003 08:15:53 -0700
Content-Disposition: inline
In-Reply-To: <20030509063321.GA3259@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Thu, 08 May 2003, Mike Anderson wrote:

> This series of patches is an update to the scsi_host sysfs / ref
> counting patches previously merged into the scsi-misc-2.5 tree. 
> 
> insmod / rmmod Testing:
> 	Legacy registration:
> 		aic7xxx_old, qlogicisp
> 		qla2xxx v8.00.00b1 - Driver oops system with garbled
> 		messages on rmmod. Does not seem related to this patch.
> 

Is the driver still oops'ng during your testing?  Could you provide
some specifics on attached storage as well as environment (fabric,
loop, hba type)?  I'll resync my working tree with scsi-misc and
perform some additional investigation.

Thanks,
Andrew Vasquez
