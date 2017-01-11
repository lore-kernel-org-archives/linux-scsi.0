From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] libsas: fix \"sysfs group not found\" warnings at port
 teardown time
Date: Wed, 11 Jan 2017 09:10:56 +0000
Message-ID: <e0b131de-baa8-f6fe-6bf0-47f140df6a82@huawei.com>
References: <20150520220858.15073.8982.stgit@dwillia2-desk3.amr.corp.intel.com>
 <a0be3adc-b9e9-86cc-773d-d209834183a9@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:8834 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756370AbdAKJLR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2017 04:11:17 -0500
In-Reply-To: <a0be3adc-b9e9-86cc-773d-d209834183a9@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: seeteena <s1seetee@linux.vnet.ibm.com>, dan.j.williams@intel.com, linux-scsi@vger.kernel.org
Cc: Yijing Wang <wangyijing@huawei.com>

On 11/01/2017 06:29, seeteena wrote:
> Hi All,
>
> Let me know if this patch is accepted in Upsteam? let me know the commit id
>

If it is the patch I think it is then it is not upstream 
(https://patchwork.kernel.org/patch/6450731/).

I did propose a patch at the end of last year which fixed the warn, but 
it introduced some other potential hotplug issue.

An engineer in my organisation proposed a re-work of libsas to fix all 
the hotplug issues, but it was not pushed and never got far:
https://lkml.org/lkml/2016/9/12/1225

John

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


