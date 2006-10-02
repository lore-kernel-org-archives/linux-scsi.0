From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 7246] New: 3w-xxxx, IOMMU and >1go RAM
Date: Mon, 2 Oct 2006 10:57:33 -0700
Message-ID: <20061002105733.a9e82ddf.akpm@osdl.org>
References: <200610021508.k92F8bmq011159@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:55517 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965193AbWJBR5q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2006 13:57:46 -0400
In-Reply-To: <200610021508.k92F8bmq011159@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>, James Bottomley <James.Bottomley@steeleye.com>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org

On Mon, 2 Oct 2006 08:08:37 -0700
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=7246
> 
>            Summary: 3w-xxxx, IOMMU and >1go RAM
>     Kernel Version: 2.6.18
>             Status: NEW
>           Severity: normal
>              Owner: scsi_drivers-other@kernel-bugs.osdl.org
>          Submitter: aarnoud@agematis.com
> 
> 
> Most recent kernel where this bug did not occur: 2.6.15-1
> Distribution: Debian Testing
> Hardware Environment: SuperMicro X6DVL-EG2, 4go RAM, 3ware 8006-2LP, 2xHitachi
> 2x80go
> Software Environment:
> Problem Description: Data corruption with kernel newer than 2.6.15-1.
> 
> Steps to reproduce: tested with most kernel 2.6.16, 2.6.17 and 2.6.18 all doing
> same corruption.
> 
> Solved the probleme leaving only 1go of RAM and setting IOMMU=off during boot
> time, with 4go RAM kernel hangs saying :
> 
> 3w-xxxx: tw_map_scsi_sg_data(): pci_map_sg() failed.
> nommu_map_sg: overflow 2053d9000+4096 of device mask ffffffff
> 3w-xxxx: tw_map_scsi_sg_data(): pci_map_sg() failed.
> nommu_map_sg: overflow 2053d9000+4096 of device mask ffffffff
> 3w-xxxx: tw_map_scsi_sg_data(): pci_map_sg() failed.
> nommu_map_sg: overflow 2053d9000+4096 of device mask ffffffff
> 
> and hangs badly.
> 

James, Adam: I recall that we had a scsi driver recently which had problems
similar to this, but I think it was with addresses over 4G, not over 1G. 
It also might not have been the 3ware driver.  Do you recall?

Alexandre, can you please send the full dmesg output for that machine?

Thanks.
