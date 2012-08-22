From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/7] Updates for be2iscsi driver
Date: Wed, 22 Aug 2012 11:33:53 -0500
Message-ID: <503509F1.9070107@cs.wisc.edu>
References: <31d949d2-1fb6-488b-b5d4-e03574436cb9@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40919 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932661Ab2HVQeH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 12:34:07 -0400
In-Reply-To: <31d949d2-1fb6-488b-b5d4-e03574436cb9@exht1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Soni Jose <sony.john-n@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, Jayamohan.Kallickal@Emulex.Com

On 08/13/2012 05:29 AM, John Soni Jose wrote:
>  Patches to update the be2iscsi driver. These patches were generated
>  against the scsi tree "scsi-misc" branch.
> 
>   Removing the iscsi_data_pdu setting.
>   Issue MBX Cmd for login to boot target in crashdump mode
>   Added Logging mechanism for the driver.
>   Format the MAC_ADDR with sysfs_format_mac.
>   Add support for configuring the VLAN on the adapter.
>   Fix a kernel panic because of TCP RST/FIN received.
>   Bump the driver version.
> 

There were some checkpatch.pl warnings about the logging, but I am not
sure if we are being strict on those. If not then it looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
