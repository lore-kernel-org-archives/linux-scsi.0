From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v2 00/19] be2iscsi driver updates
Date: Wed, 24 Oct 2012 02:01:00 -0500
Message-ID: <5087922C.4090000@cs.wisc.edu>
References: <257c4982-e7d0-4b5e-9eee-5f60f4c49dba@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43497 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933282Ab2JXHBI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2012 03:01:08 -0400
In-Reply-To: <257c4982-e7d0-4b5e-9eee-5f60f4c49dba@CMEXHTCAS1.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Soni Jose <sony.john-n@emulex.com>
Cc: linux-scsi@vger.kernel.org

On 10/19/2012 06:11 PM, John Soni Jose wrote:
>  V2 patches for be2iscsi driver updates. Fixed the review comments
>  with this patch. These patches were generated aganist scsi-misc branch.
> 
>   be2iscsi: Fix the issue with soft reset.
>   be2iscsi: Display Completion Event string instead of Opcode
>   be2iscsi: Fix memory leak in control path of driver
>   be2iscsi: Fix max supported EQ count to 8.
>   be2iscsi: Display driver name and version in device attribute
>   be2iscsi: Issue an FLR when driver is loaded
>   be2iscsi: Fix kernel panic in blk_iopoll disable mode.
>   be2iscsi: Fix return value and typo.
>   be2iscsi: Fix driver support for an adapter.
>   be2iscsi: Fix max EQ supported by the driver.
>   be2iscsi: Fix support for handling CQ_CREATE V2 version.
>   be2iscsi: Fix support for V2 version of WRB.
>   be2iscsi: Fix session update context with V2 version.
>   be2iscsi: Fix Task Completion Event handling
>   be2iscsi: Fix issue of displaying adapter family.
>   be2iscsi: Fix the copyright information
>   be2iscsi: Fix for MBX timeout issue
>   be2iscsi: Fix Unrecoverable Error Detection
>   be2iscsi: Bump the driver version
> 

Patches look ok overall. Just those 2 issues which might be ok with James.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

