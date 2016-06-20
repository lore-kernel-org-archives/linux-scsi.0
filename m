From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] cxlflash: Shutdown notify support for CXL Flash cards
Date: Mon, 20 Jun 2016 12:25:21 -0500
Message-ID: <36CC19DB-79CA-4D53-BE16-AE9B84F7AD71@linux.vnet.ibm.com>
References: <1466034460-17797-1-git-send-email-ukrishn@linux.vnet.ibm.com> <1466034597-17950-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42414 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756259AbcFTRZu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2016 13:25:50 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5KHOVJE023613
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2016 13:25:29 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
	by mx0b-001b2d01.pphosted.com with ESMTP id 23myww5b8p-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2016 13:25:29 -0400
Received: from localhost
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Mon, 20 Jun 2016 11:25:29 -0600
In-Reply-To: <1466034597-17950-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

> On Jun 15, 2016, at 6:49 PM, Uma Krishnan <ukrishn@linux.vnet.ibm.com> wrote:
> 
> Some CXL Flash cards need notification of device shutdown
> in order to flush pending I/Os.
> 
> A PCI notification hook for shutdown has been added where
> the driver notifies the card and returns. When the device
> is removed in the PCI remove path, notification code will
> wait for shutdown processing to complete.
> 
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

