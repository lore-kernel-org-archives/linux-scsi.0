From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH 1/2] nvmet_fc: add defer_req callback for deferment of cmd
 buffer return
Date: Wed, 2 Aug 2017 07:29:45 -0700
Message-ID: <705523d4-8452-814c-0486-71ddde698e73@gmail.com>
References: <20170801221240.31723-1-jsmart2021@gmail.com>
 <20170801221240.31723-2-jsmart2021@gmail.com>
 <20170802081617.GD4256@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:37034 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752185AbdHBO3s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2017 10:29:48 -0400
Received: by mail-pf0-f195.google.com with SMTP id p13so2703594pfd.4
        for <linux-scsi@vger.kernel.org>; Wed, 02 Aug 2017 07:29:47 -0700 (PDT)
In-Reply-To: <20170802081617.GD4256@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-nvme@lists.infradead.org, James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 8/2/2017 1:16 AM, Johannes Thumshirn wrote:
>> +	for (;;) {
>> +		deferfcp = list_first_entry_or_null(&queue->pending_cmd_list,
>> +				struct nvmet_fc_defer_fcp_req, req_list);
>> +		if (!deferfcp)
>> +			break;
> 
>          while ((deferfcp = list_first_entry_or_null(&queue->pending_cmd_list,
> 				struct nvmet_fc_defer_fcp_req,
> 				req_list)) != NULL) {
> ?

To me - this is harder to read. But not a big deal.

-- james
