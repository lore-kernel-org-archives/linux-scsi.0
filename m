From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/6] cxlflash: Remove adapter file descriptor cache
Date: Fri, 19 Aug 2016 07:18:25 -0500
Message-ID: <1b1f9d2f-c58f-44a1-9e9c-72f54fabf58b@linux.vnet.ibm.com>
References: <1470785888-9112-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1470786002-9342-1-git-send-email-mrochs@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54189 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750721AbcHSMSa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Aug 2016 08:18:30 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7JCEcFo100717
        for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2016 08:18:29 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 24wfj5gv2c-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 19 Aug 2016 08:18:29 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
        Fri, 19 Aug 2016 06:18:27 -0600
In-Reply-To: <1470786002-9342-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

Acked-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>


On 8/9/2016 6:40 PM, Matthew R. Ochs wrote:
> The adapter file descriptor was previously cached within the kernel
> for a given context in order to support performing a close on behalf
> of an application. This is no longer needed as applications are now
> required to perform a close on the adapter file descriptor.
>
> Inspired-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

