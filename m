From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5] ibmvscsi: Remove unnecessary map_sg check
Date: Thu, 14 Jun 2007 08:38:25 -0500
Message-ID: <467144D1.1060309@linux.vnet.ibm.com>
References: <11817727312836-patch-mail.ibm.com> <4670701E.2010404@garzik.org>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:55887 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbXFNNih (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2007 09:38:37 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5EDcaN1011415
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jun 2007 09:38:36 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5EDcUSo205110
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jun 2007 07:38:32 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5EDcSWW011861
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jun 2007 07:38:29 -0600
In-Reply-To: <4670701E.2010404@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: santil@linux.vnet.ibm.com, rcjenn@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Brian King wrote:
>> Since sg_tablesize is set appropriately in the scsi host template,
>> remove the unnecessary check to make sure it is not exceeded
>> following the dma_map_sg call.
>>
>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>> ---
>>
>>  linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c |    7 -------
>>  1 file changed, 7 deletions(-)
> 
> Patches 1-5 look OK to me... modulo the question I just sent

Thanks for the review

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
