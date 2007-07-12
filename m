From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH] mpt fusion: add sysfs attributes to display IOC parameters
Date: Thu, 12 Jul 2007 10:30:51 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70850E7F@NAMAIL4.ad.lsil.com>
References: <469636CD.8000902@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:52218 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758933AbXGLQcp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jul 2007 12:32:45 -0400
Content-class: urn:content-classes:message
In-Reply-To: <469636CD.8000902@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com, "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Thursday, July 12, 2007 8:12 AM,  Brian King wrote:
> This should be removed from the patch. This information is already
> available in sysfs: /sys/module/mptscsih/version
> 

He is correct, the version is there in /sys/module/mptsas/version as
well.   Please repost the patch with this removed.

Thanks,
Eric

