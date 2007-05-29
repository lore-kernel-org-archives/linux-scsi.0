From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: Patch added to scsi-pending-2.6:   [SCSI] ipr: convert to use
 the data buffer accessors
Date: Tue, 29 May 2007 16:42:30 -0500
Message-ID: <465C9E46.3030808@linux.vnet.ibm.com>
References: <200705271738.l4RHc53K014214@hera.kernel.org>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:39905 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbXE2Vme (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 May 2007 17:42:34 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4TLgXbY014239
	for <linux-scsi@vger.kernel.org>; Tue, 29 May 2007 17:42:33 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4TLgWc1198926
	for <linux-scsi@vger.kernel.org>; Tue, 29 May 2007 15:42:32 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4TLgWGc015622
	for <linux-scsi@vger.kernel.org>; Tue, 29 May 2007 15:42:32 -0600
In-Reply-To: <200705271738.l4RHc53K014214@hera.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Acked-by: Brian King <brking@linux.vnet.ibm.com>


James Bottomley wrote:
> Your commit:
> 
>     [SCSI] ipr: convert to use the data buffer accessors
>     
>     - remove the unnecessary map_single path.
>     
>     - convert to use the new accessors for the sg lists and the
>     parameters.
>     
>     Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>     Cc: Brian King <brking@linux.vnet.ibm.com>
>     Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
> 
> has been added to the pending SCSI tree
> You can find it here:
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-pending-2.6.git;a=commit;h=7e9f7162968845324e123180b0d8bea8f93f6ef5
> 
> Please note the scsi-misc-2.6 tree will rebase, so this URL may not be
> permanent.  You will get another email if the tree rebases.
> 
> This patch is pending because it requires ACKs from:
> 
> Brian King <brking@linux.vnet.ibm.com>
> 
> If those are received it may be moved into one of the upstream SCSI queues
> 
> James Bottomley
> 
> P.S. If you find this email unwanted, set up a procmail rule junking on
> the header:
> 
> X-Git-Tree: SCSI


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
