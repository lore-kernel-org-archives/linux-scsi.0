From: Farhan Ali <alifm@linux.vnet.ibm.com>
Subject: Re: Kernel crash with 4.10 trying to remove scsi disks
Date: Mon, 27 Feb 2017 17:28:11 -0500
Message-ID: <e00a13e6-8c3b-a907-042e-1b54f7daf1b4@linux.vnet.ibm.com>
References: <48a44b52-f721-709f-10e1-6787a0774515@linux.vnet.ibm.com>
 <fd33b84d-7362-2a6a-a2c8-6cc62ba00510@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58221 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751929AbdB0W3i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Feb 2017 17:29:38 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1RMJFBG057790
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2017 17:28:14 -0500
Received: from e38.co.us.ibm.com (e38.co.us.ibm.com [32.97.110.159])
        by mx0b-001b2d01.pphosted.com with ESMTP id 28vrp829g4-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2017 17:28:14 -0500
Received: from localhost
        by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <alifm@linux.vnet.ibm.com>;
        Mon, 27 Feb 2017 15:28:13 -0700
In-Reply-To: <fd33b84d-7362-2a6a-a2c8-6cc62ba00510@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@de.ibm.com>

Hi Johannes,

I don't think this crash was newly introduced with 4.10. I had another 
run with 4.10 and that one completed successfully. So not sure what is 
causing this kernel crash.

Thanks
Farhan

On 02/27/2017 05:35 AM, Johannes Thumshirn wrote:
> On 02/24/2017 04:07 PM, Farhan Ali wrote:
>> Hello,
>>
>> I have noticed a kernel crash with 4.10 kernel in our s390 environment,
>> running a test trying to remove scsi disks. Here is a snippet of the
>> kernel crash message:
>
> Hi Farhan,
>
> Is this crash newly introduced with 4.10? Do you maybe have a chance to
> bisect it?
>
> Thanks,
> 	Johannes
>
