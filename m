From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH V2 0/8] be2iscsi: Update to 10.2.125.0
Date: Wed, 05 Feb 2014 15:44:42 -0600
Message-ID: <52F2B0CA.7020609@cs.wisc.edu>
References: <1390979807-16718-1-git-send-email-Jayamohan.Kallickal@emulex.com> <1390979807-16718-9-git-send-email-Jayamohan.Kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35872 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbaBEVpK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Feb 2014 16:45:10 -0500
In-Reply-To: <1390979807-16718-9-git-send-email-Jayamohan.Kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <jayamohank@gmail.com>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

On 01/29/2014 01:16 AM, Jayamohan Kallickal wrote:
> From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> 
> This patchset updates be2iscsi driver to 10.2.125.0. 
> 
> Regarding comments by Mike Christie  on Version 1 
> 
>  Patch 5/7) - converted to common function
>  Patch 4/7  - Will withdraw for now as there is lots of
> 		changes to be done.
> 
> These patches are based of scsi.git scsi
> 
>  0001 - Fix handling timed out MBX completion from FW
>  0002 - Fix port speed typo in driver
>  0003 - Fix IRQ_Affinity support in driver
>  0004 - Fix doorbell format for EQ CQ RQ per SLI
>  0005 - Fix the session cleanup when reboot shutdown
>  0006 - Fix scsi_cmnd leakage in driver
>  0007 - Fix DMA Out of SW IOMMU space error
>  0008 - Bump the driver version
> 
> 
> Thanks
> Jay
> 
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> ---
> 

Ok, looks like Jay dropped 3/8 and the other patches look ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
