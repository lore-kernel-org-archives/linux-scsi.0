From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH] tcmu: Oops in unmap_thread_fn()
Date: Wed, 8 Nov 2017 16:41:07 -0600
Message-ID: <d4d2840b-d453-e67a-01b2-662a29bc134c@linux.vnet.ibm.com>
References: <20170801200917.brigs5x47eujfx7a@mwanda>
 <1502062073.22966.45.camel@haakon3.daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52034 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752670AbdKHWlN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2017 17:41:13 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vA8MdQUZ039508
        for <linux-scsi@vger.kernel.org>; Wed, 8 Nov 2017 17:41:12 -0500
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2e4adnsann-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 08 Nov 2017 17:41:12 -0500
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Wed, 8 Nov 2017 17:41:11 -0500
In-Reply-To: <1502062073.22966.45.camel@haakon3.daterainc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: Xiubo Li <lixiubo@cmss.chinamobile.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org



On 8/6/17 6:27 PM, Nicholas A. Bellinger wrote:
> On Tue, 2017-08-01 at 23:09 +0300, Dan Carpenter wrote:
>> Calling list_del() on the iterator pointer in list_for_each_entry() will
>> cause an oops.  We need to user the _safe() version for that.
>>
>> Fixes: c73d02f63c16 ("tcmu: Add fifo type waiter list support to avoid starvation")
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>
> Applied to target-pending/for-next.
>
> Thanks DanC.
>
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Also missing.

-Bryant
