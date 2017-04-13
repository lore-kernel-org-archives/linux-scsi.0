From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 15/17] cxlflash: Support multiple hardware queues
Date: Thu, 13 Apr 2017 17:09:23 -0500
Message-ID: <29FD7426-117A-460F-853A-614E69250A42@linux.vnet.ibm.com>
References: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1492024542-56194-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49667 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753547AbdDMWJp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Apr 2017 18:09:45 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3DLwop1107023
        for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2017 18:09:39 -0400
Received: from e15.ny.us.ibm.com (e15.ny.us.ibm.com [129.33.205.205])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29sw2bmav2-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 13 Apr 2017 18:09:39 -0400
Received: from localhost
        by e15.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
        Thu, 13 Apr 2017 18:09:38 -0400
In-Reply-To: <1492024542-56194-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

> On Apr 12, 2017, at 2:15 PM, Uma Krishnan <ukrishn@linux.vnet.ibm.com> wrote:
> 
> Introduce multiple hardware queues to improve legacy I/O path performance.
> Each hardware queue is comprised of a master context and associated I/O
> resources. The hardware queues are initially implemented as a static array
> embedded in the AFU. This will be transitioned to a dynamic allocation in a
> later series to improve the memory footprint of the driver.
> 
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

Looks good!

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
