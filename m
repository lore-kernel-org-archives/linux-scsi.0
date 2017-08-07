From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH v2 04/20] lpfc: Fix oops when NVME Target is discovered in
 a nonNVME environment
Date: Mon, 7 Aug 2017 13:34:37 -0700
Message-ID: <60fb66dd-be12-86ec-9293-021bcfbd4029@gmail.com>
References: <20170805004731.1335-1-jsmart2021@gmail.com>
 <20170805004731.1335-5-jsmart2021@gmail.com>
 <20170807080024.GH3978@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34293 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751589AbdHGUel (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2017 16:34:41 -0400
Received: by mail-qk0-f195.google.com with SMTP id q66so1561481qki.1
        for <linux-scsi@vger.kernel.org>; Mon, 07 Aug 2017 13:34:41 -0700 (PDT)
In-Reply-To: <20170807080024.GH3978@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 8/7/2017 1:00 AM, Johannes Thumshirn wrote:
> On Fri, Aug 04, 2017 at 05:47:15PM -0700, James Smart wrote:
>> From: Dick Kennedy <dick.kennedy@broadcom.com>
>>
>> lpfc oops when it discovers a NVME target but is configured for SCSI
>> only operation. Oops is in lpfc_nvme_register_port+0x33/0x300.
> 
> Why does it even call lpfc_nvme_register_rport if it isn't configured for
> handling NVMe?
> 

That was the bug....  it got confused about protocol support.

-- james
