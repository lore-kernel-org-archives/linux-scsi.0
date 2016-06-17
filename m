From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] cxlflash: Add device dependent flags
Date: Thu, 16 Jun 2016 22:00:12 -0500
Message-ID: <576367BC.6060701@linux.vnet.ibm.com>
References: <1466034460-17797-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1466034578-17914-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33863 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754559AbcFQC7g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2016 22:59:36 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5H2xGZV024480
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2016 22:59:35 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23kqt2vmqg-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2016 22:59:35 -0400
Received: from localhost
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Thu, 16 Jun 2016 20:59:34 -0600
In-Reply-To: <1466034578-17914-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

On 6/15/2016 6:49 PM, Uma Krishnan wrote:
> Device dependent flags are needed to support functions that are
> specific to a particular device.
>


Acked-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>


