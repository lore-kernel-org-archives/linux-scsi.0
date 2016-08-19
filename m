From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/6] cxlflash: Transition to application close model
Date: Thu, 18 Aug 2016 22:53:24 -0500
Message-ID: <4f79ec84-ba9d-9c7f-6629-03d58593282c@linux.vnet.ibm.com>
References: <1470785888-9112-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1470785992-9274-1-git-send-email-mrochs@linux.vnet.ibm.com>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33613 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752511AbcHSDx3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Aug 2016 23:53:29 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7J3mja1120284
        for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2016 23:53:28 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
        by mx0a-001b2d01.pphosted.com with ESMTP id 24v7skh80p-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2016 23:53:28 -0400
Received: from localhost
        by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
        Thu, 18 Aug 2016 21:53:27 -0600
In-Reply-To: <1470785992-9274-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>


Acked-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>


On 8/9/2016 6:39 PM, Matthew R. Ochs wrote:
> Caching the adapter file descriptor and performing a close on behalf
> of an application is a poor design. This is due to the fact that once
> a file descriptor in installed, it is free to be altered without the
> knowledge of the cxlflash driver. This can lead to inconsistencies
> between the application and kernel. Furthermore, the nature of the
> former design is more exploitable and thus should be abandoned.
>
> To support applications performing a close on the adapter file that
> is associated with a context, a new flag is introduced to the user
> API to indicate to applications that they are responsible for the
> close following the cleanup (detach) of a context. The documentation
> is also updated to reflect this change in behavior.
>
> Inspired-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

