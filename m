From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] cxlflash: Add device dependent flags
Date: Mon, 20 Jun 2016 12:16:06 -0500
Message-ID: <742D7B6C-4A3F-4B9D-81DF-B37278510DE9@linux.vnet.ibm.com>
References: <1466034460-17797-1-git-send-email-ukrishn@linux.vnet.ibm.com> <1466034578-17914-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53998 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754198AbcFTRR3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2016 13:17:29 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5KH97YN095758
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2016 13:16:21 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
	by mx0b-001b2d01.pphosted.com with ESMTP id 23n0esm6ha-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2016 13:16:21 -0400
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Mon, 20 Jun 2016 13:16:16 -0400
In-Reply-To: <1466034578-17914-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

> On Jun 15, 2016, at 6:49 PM, Uma Krishnan <ukrishn@linux.vnet.ibm.com> wrote:
> 
> Device dependent flags are needed to support functions that are
> specific to a particular device.
> 
> One such case is - some CXL Flash cards need to be notified of
> device shutdown. For other CXL devices, this feature does not prove
> to be useful yet. Such distinct features need to be identified in
> the driver to bypass or invoke specific functionality.
> 
> In this patch, a member 'flags' has been added to device dependent
> values. These flags will be used and expanded in the future to
> support various device specific functions.
> 
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>


