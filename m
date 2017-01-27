From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH] target: Add WRITE_VERIFY_16 Support
Date: Fri, 27 Jan 2017 14:57:11 -0600
Message-ID: <1db8d95d-d586-c4bf-59ce-4dc8ada510c2@linux.vnet.ibm.com>
References: <1485550152-18623-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <1485550543.4267.27.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:39666 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751144AbdA0U5R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Jan 2017 15:57:17 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0RKmfux020909
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jan 2017 15:57:16 -0500
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0a-001b2d01.pphosted.com with ESMTP id 288855vnh6-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jan 2017 15:57:16 -0500
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Fri, 27 Jan 2017 15:57:15 -0500
In-Reply-To: <1485550543.4267.27.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "mikecyr@linux.vnet.ibm.com" <mikecyr@linux.vnet.ibm.com>


> On Fri, 2017-01-27 at 14:49 -0600, Bryant G. Ly wrote:
>> For clients who want to utilize more than 2GB you need
>> WRITE AND VERIFY 16 support.
> Hello Bryant,
>
> This patch introduces a bug for WRITE AND VERIFY(16) parsing that already
> exists for WRITE AND VERIFY(10) parsing, namely that the value of the BYTCHK
> field is ignored. Is it OK for you to wait a few weeks with adding WRITE AND
> VERIFY(16) support and to come back to this after I have posted my WRITE AND
> VERIFY(10) fix?
>
> Bart.

Sounds good, thanks. I'll have to look at your patch sets that fixes that bug.


