From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH 04/15] lpfc: Fix nvmet RQ resource needs for large block
 writes.
Date: Mon, 15 May 2017 14:48:53 -0700
Message-ID: <e822a05f-c59e-4f1b-c6a9-17580ebd98fb@gmail.com>
References: <20170510190713.30171-1-jsmart2021@gmail.com>
 <20170510190713.30171-5-jsmart2021@gmail.com>
 <628697c5-6273-f87b-6f39-145bbeeb0741@suse.de>
Reply-To: jsmart2021@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33533 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750710AbdEOVs6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 May 2017 17:48:58 -0400
Received: by mail-wm0-f65.google.com with SMTP id y10so32072991wmh.0
        for <linux-scsi@vger.kernel.org>; Mon, 15 May 2017 14:48:58 -0700 (PDT)
In-Reply-To: <628697c5-6273-f87b-6f39-145bbeeb0741@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 5/10/2017 11:18 PM, Hannes Reinecke wrote:
> On 05/10/2017 09:07 PM, James Smart wrote:
>> Large block writes to the nvme target were failing because
>> the default number of RQs posted was insufficient.
>>
>> Expand the NVMET RQs to 2048 RQEs and ensure a minimun of 2048
>                                                          512^^^^
> The minimum is actually 512, isn't it?

effectively. Reworked patch to set minimum at 512.

Will repost.

-- james
