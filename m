From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH] mpt fusion: add sysfs attributes to display IOC parameters
Date: Tue, 17 Jul 2007 10:56:04 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7088464A@NAMAIL4.ad.lsil.com>
References: <20070717090913.GA8157@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60766 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756323AbXGQQ4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 12:56:17 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070717090913.GA8157@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, brking@linux.vnet.ibm.com

On Tuesday, July 17, 2007 3:09 AM,  Prakash, Sathya wrote:
> Reposting as this patch is not visible in the list yet.
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
> ---


ACK

Eric Moore
