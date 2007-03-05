From: Andreas Moroder <andreas.moroder@sb-brixen.it>
Subject: Raid not seen as raind in SLES 10 Installation
Date: Mon, 05 Mar 2007 15:22:03 +0100
Message-ID: <esh92a$5si$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:54058 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933403AbXCEOWm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Mar 2007 09:22:42 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1HOE53-0001y9-3o
	for linux-scsi@vger.kernel.org; Mon, 05 Mar 2007 15:22:25 +0100
Received: from merlin2.provinz.bz.it ([62.101.0.30])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 05 Mar 2007 15:22:25 +0100
Received: from andreas.moroder by merlin2.provinz.bz.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 05 Mar 2007 15:22:25 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

we have a Fujitsu-Siemens TX200 with a onboard AIC-7902W adapter and 4 
disks. We have set them up as two pair of RAID-1 disks.

The bios startup-screen shows us two pair of RAID1 disks.

When we try to install SLES10 we see 4 disks !

How can we tell Linux that there are only two RAID and why does the 
kernel see the disks ? Should this not be hidden by the AIC hostadapter ?
Is it the INT13 that makes this problems ?

Thanks
Andreas

