From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: no INQUIRY from userspace please (was Re: [PATCH 7/9] scsi_dh: Add
 support for SDEV_PASSIVE)
Date: Thu, 07 Feb 2008 11:08:24 +0100
Message-ID: <47AAD898.30004@s5r6.in-berlin.de>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain> <20080124003203.18871.52040.sendpatchset@localhost.localdomain> <1202151498.3096.84.camel@localhost.localdomain> <1202156151.13537.14.camel@linuxchandra> <1202156914.3096.112.camel@localhost.localdomain> <47A8C14A.3030207@cs.wisc.edu> <20080205215657.GA20963@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:58154 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759272AbYBGKIZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 05:08:25 -0500
In-Reply-To: <20080205215657.GA20963@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, sekharan@us.ibm.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

Mike Anderson wrote:
> A number of user apps like lvm scanning that execute media access commands
> already have filter capability to filter devices that one does not want to
> scan. Another class of device scanners just use inquiries which are not
> effected by the passive state (though some could probably use udevinfo and
> reduce the amount of repeated SCSI inquiries execute on the system.

To expand on this:

At least on desktop systems and SOHO server systems, userspace should
_never_ issue INQUIRY.  There are too many broken firmwares out there
which assume that there will never be more than one INQUIRY sent.  They
start to return garbled data or crash if they get a second INQUIRY.
-- 
Stefan Richter
-=====-==--- --=- --===
http://arcgraph.de/sr/
