From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 09/17] cxlflash: Create character device to provide host
 management interface
Date: Thu, 22 Jun 2017 14:56:52 -0500
Message-ID: <439AB50D-8EC5-4996-AC48-F0E55CACCA98@linux.vnet.ibm.com>
References: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1498097718-9006-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45148 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751147AbdFVT5C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jun 2017 15:57:02 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5MJrhAM056754
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jun 2017 15:57:02 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2b8fph54fm-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jun 2017 15:57:02 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
        Thu, 22 Jun 2017 13:57:01 -0600
In-Reply-To: <1498097718-9006-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

> On Jun 21, 2017, at 9:15 PM, Uma Krishnan <ukrishn@linux.vnet.ibm.com> wrote:
> 
> The cxlflash driver currently lacks host management interface. Future
> devices supported by cxlflash will provide a variety of host-wide
> management functions. Examples include LUN provisioning, hardware debug
> support, and firmware download.
> 
> In order to provide a way to manage the device, a character device will
> be created during probe of each adapter. This device will support a set of
> ioctls defined in the SISLite specification from which administrators can
> manage the adapter.
> 
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
