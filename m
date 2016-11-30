From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 05/14] cxlflash: Remove unused buffer from AFU command
Date: Wed, 30 Nov 2016 16:03:37 -0600
Message-ID: <cbac1db4-468e-ef72-c96f-51634eb8005f@linux.vnet.ibm.com>
References: <1480379984-60114-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1480380121-60346-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54862 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756915AbcK3WC5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Nov 2016 17:02:57 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAULtdvT146567
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2016 17:02:56 -0500
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0a-001b2d01.pphosted.com with ESMTP id 27238sbucy-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2016 17:02:56 -0500
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 30 Nov 2016 15:02:54 -0700
In-Reply-To: <1480380121-60346-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

> From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
>
> The cxlflash driver originally required a per-command 4K buffer that
> hosted data passed to the AFU. When the routines that initiate AFU
> and internal SCSI commands were refactored to use scsi_execute(), the
> need for this buffer became obsolete. As it is no longer necessary,
> the buffer is removed.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

Acked-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>

