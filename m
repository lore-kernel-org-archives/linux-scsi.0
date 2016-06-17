From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] cxlflash: Shutdown notify support for CXL Flash cards
Date: Fri, 17 Jun 2016 08:46:14 -0500
Message-ID: <5763FF26.2060800@linux.vnet.ibm.com>
References: <1466034460-17797-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1466034597-17950-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19559 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbcFQNpi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2016 09:45:38 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5HDhwGT080718
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jun 2016 09:45:38 -0400
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23kr62r68c-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jun 2016 09:45:38 -0400
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Fri, 17 Jun 2016 09:45:36 -0400
In-Reply-To: <1466034597-17950-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

On 6/15/2016 6:49 PM, Uma Krishnan wrote:
> Some CXL Flash cards need notification of device shutdown
> in order to flush pending I/Os.
>
> A PCI notification hook for shutdown has been added where
> the driver notifies the card and returns. When the device
> is removed in the PCI remove path, notification code will
> wait for shutdown processing to complete.
>
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

Acked-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>



