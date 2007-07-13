From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH] mpt fusion: add sysfs attributes to display IOC parameters
Date: Fri, 13 Jul 2007 11:12:30 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7085119D@NAMAIL4.ad.lsil.com>
References: <20070713041041.GA5149@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:46614 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757316AbXGMRMf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jul 2007 13:12:35 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070713041041.GA5149@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: brking@linux.vnet.ibm.com

On  Thursday, July 12, 2007 10:11 PM, Prakash, Sathya wrote: 

> 
> Resubmitting with the following change suggested by Brian King:
> The driver version from scsi_host attribute is redundant as 
> it is already 
> available in sysfs: /sys/module/mptscsih/version. 
> So it is removed from the patch
> 
> ---
> New sysfs scsi_host attributes are added to provide 
> information about Firmware
> version, BIOS version, MPI version and other product related 
> information.
> 
> signed-off-by: Sathya Praksh <sathya.prakash@lsi.com>
> 

ACK, please apply.

Eric Moore
