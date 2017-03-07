From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] lpfc: Finalize Kconfig options for nvme
Date: Tue, 7 Mar 2017 13:37:35 -0800
Message-ID: <6ae124f3-b5c7-655a-fda8-cb08ec71dab9@broadcom.com>
References: <1488914228-7289-1-git-send-email-jsmart2021@gmail.com>
 <20170307212351.GA5697@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:34371 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751093AbdCGXlK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2017 18:41:10 -0500
Received: by mail-qk0-f180.google.com with SMTP id p64so33232998qke.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Mar 2017 15:39:32 -0800 (PST)
In-Reply-To: <20170307212351.GA5697@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Dick Kennedy <dick.kennedy@broadcom.com>



On 3/7/2017 1:23 PM, Christoph Hellwig wrote:
>> +#if defined(CONFIG_NVME_FC)
>> +#define CONFIG_LPFC_NVME_INITIATOR
>> +#endif
>> +
>> +#if defined(CONFIG_NVME_TARGET_FC)
>> +#define CONFIG_LPFC_NVME_TARGET
>> +#endif
> The CONFIG_* namespace is reserved for Kconfig defined symbols.
>
> Also I think the above is wrong if the nvme fc core code is built
> modular.  I think you want to replace all occurances of
>
> #ifdef CONFIG_LPFC_NVME_INITIATOR
>
> with
>
> if (IS_ENABLED(CONFIG_NVME_FC))
>
> and vice versa for the taget.

make sense

-- james
