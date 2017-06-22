From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 05/17] cxlflash: Handle AFU sync failures
Date: Thu, 22 Jun 2017 14:55:42 -0500
Message-ID: <E4210FEF-3158-466C-9878-F59E3B53842F@linux.vnet.ibm.com>
References: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1498097670-8862-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36260 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751147AbdFVTzu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jun 2017 15:55:50 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5MJrkYF143306
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jun 2017 15:55:49 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2b87shxbxc-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jun 2017 15:55:49 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
        Thu, 22 Jun 2017 13:55:48 -0600
In-Reply-To: <1498097670-8862-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

> On Jun 21, 2017, at 9:14 PM, Uma Krishnan <ukrishn@linux.vnet.ibm.com> wrote:
> 
> AFU sync operations are not currently evaluated for failure. This is
> acceptable for paths where there is not a dependency on the AFU being
> consistent with the host. Examples include link reset events and LUN
> cleanup operations. On paths where there is a dependency, such as a LUN
> open, a sync failure should be acted upon.
> 
> In the event of AFU sync failures, either log or cleanup as appropriate for
> operations that are dependent on a successful sync completion.
> 
> Update documentation to reflect behavior in the event of an AFU sync
> failure.
> 
> Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
