From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] scsi: mpt3sas: fix oops in error handlers after
 shutdown/unload
Date: Thu, 15 Feb 2018 10:10:41 -0200
Message-ID: <46d49afa-2e27-fe98-7040-fddc5891f122@linux.vnet.ibm.com>
References: <1517523386-9868-1-git-send-email-mauricfo@linux.vnet.ibm.com>
 <2fd5c995219c5e07ef04765f67b9b8a7@mail.gmail.com>
 <c2d58b10-b927-4a06-5edf-69f9fdb05bbd@linux.vnet.ibm.com>
 <91f269efc5383e1d946f1ab793ad046b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33488 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967889AbeBOMKu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Feb 2018 07:10:50 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w1FCAehc099151
        for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2018 07:10:50 -0500
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2g55sfa5p8-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2018 07:10:48 -0500
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Thu, 15 Feb 2018 07:10:47 -0500
In-Reply-To: <91f269efc5383e1d946f1ab793ad046b@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, linux-scsi@vger.kernel.org, Bart.VanAssche@wdc.com
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, dougmill@linux.vnet.ibm.com

Hi Sreekanth,

On 02/15/2018 03:48 AM, Sreekanth Reddy wrote:
> During the shutdown time, I don't want the outstanding IOs to timeout due to
> disabling of interrupts and go the TM path. So I wanted to clear out all the
> Outstanding IOs in the shutdown path itself instead of clearing them in TM
> path.

Ah. I see. I didn't realize that. Good catch.

> But if there are already some TMs are outstanding while initiating the
> shutdown operation then your patch looks good to me.

Ok. Thanks for the review.

> May be can you include my set of changes along with your solution?

Sure. I'll send a v3 with both parts and due credit.

cheers,
Mauricio
