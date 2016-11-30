From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 07/14] cxlflash: Use cmd_size for private commands
Date: Wed, 30 Nov 2016 16:05:14 -0600
Message-ID: <da3ca937-fbb5-c015-8b89-e9e0d321d401@linux.vnet.ibm.com>
References: <1480379984-60114-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1480380139-60425-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47872 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753027AbcK3WEc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Nov 2016 17:04:32 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAUM47H6035967
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2016 17:04:32 -0500
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2724mwy6y8-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2016 17:04:32 -0500
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 30 Nov 2016 15:04:31 -0700
In-Reply-To: <1480380139-60425-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

This looks good !

> From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
>
> Instead of using a private pool of AFU commands, use cmd_size to prime
> the private pool of SCSI commands such that they are allocated with a
> size large enough to contain an aligned AFU command. Use scsi_cmd_priv()
> to derive the aligned/zeroed private command on queuecommand and TMF
> paths. Remove cmd_checkout() as it is no longer required. The remaining
> AFU private command infrastructure will be removed in a cleanup commit.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

Acked-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

