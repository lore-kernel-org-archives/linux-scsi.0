From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCHv2] tcmu: Add fifo type waiter list support to avoid
 starvation
Date: Wed, 8 Nov 2017 16:35:42 -0600
Message-ID: <65f2456a-057c-9e68-be34-b89fd560b5ca@linux.vnet.ibm.com>
References: <1499843767-17420-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <1501452645.1499.21.camel@haakon3.daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39956 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752703AbdKHWfr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2017 17:35:47 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vA8MTtkY084101
        for <linux-scsi@vger.kernel.org>; Wed, 8 Nov 2017 17:35:46 -0500
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2e45u67b8t-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 08 Nov 2017 17:35:46 -0500
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Wed, 8 Nov 2017 17:35:46 -0500
In-Reply-To: <1501452645.1499.21.camel@haakon3.daterainc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, lixiubo@cmss.chinamobile.com
Cc: mchristi@redhat.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org


On 7/30/17 5:10 PM, Nicholas A. Bellinger wrote:

> Hi Xiubo,
>
> Apologies for the delayed response.  Comments below.
>
> On Wed, 2017-07-12 at 15:16 +0800, lixiubo@cmss.chinamobile.com wrote:
>> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
>>
>> The fifo type waiter list will hold the udevs who are waiting for the
>> blocks from the data global pool. The unmap thread will try to feed the
>> first udevs in waiter list, if the global free blocks available are
>> not enough, it will stop traversing the list and abort waking up the
>> others.
>>
>> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
>> ---
>>  drivers/target/target_core_user.c | 104 ++++++++++++++++++++++++++++++++------
>>  1 file changed, 88 insertions(+), 16 deletions(-)
>>
> Applied to target-pending/for-next.
>
> Thanks Xiubo + MNC.
>
Hi Nick, 

Do you know what ever happened to this patch? You mentioned that you had applied the patch but I don't see it anywhere in your tree.

Thanks, 

Bryant
