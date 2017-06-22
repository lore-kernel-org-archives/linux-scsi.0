From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 06/17] cxlflash: Track pending scsi commands in each
 hardware queue
Date: Thu, 22 Jun 2017 14:56:02 -0500
Message-ID: <6EB7F7D5-5BE3-4387-BC22-08661695B3C5@linux.vnet.ibm.com>
References: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1498097683-8898-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45107 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751147AbdFVT4L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jun 2017 15:56:11 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5MJrg6K093968
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jun 2017 15:56:10 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2b8kvr1c6h-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jun 2017 15:56:10 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
        Thu, 22 Jun 2017 13:56:08 -0600
In-Reply-To: <1498097683-8898-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

> On Jun 21, 2017, at 9:14 PM, Uma Krishnan <ukrishn@linux.vnet.ibm.com> wrote:
> 
> Currently, there is no book keeping of the pending scsi commands in the
> cxlflash driver. This lack of tracking in-flight requests is too
> restrictive and requires a heavy-hammer reset each time an adapter error is
> encountered. Additionally, it does not allow for commands to be properly
> retried.
> 
> In order to avoid this problem and to better handle error path command
> cleanup, introduce a linked list for each hardware queue that tracks
> pending commands.
> 
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
