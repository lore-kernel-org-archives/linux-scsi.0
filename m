From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH v2 02/15] lpfc: Fix system crash when port is reset.
Date: Wed, 17 May 2017 11:49:10 -0700
Message-ID: <c2bf3df0-e65e-2f1c-5bb7-cb5b62697e30@gmail.com>
References: <20170515222052.26004-1-jsmart2021@gmail.com>
 <20170515222052.26004-3-jsmart2021@gmail.com>
 <73cdc776-8eea-b63b-89af-ffa9829e1f9d@linux.vnet.ibm.com>
Reply-To: jsmart2021@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35619 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750838AbdEQStO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2017 14:49:14 -0400
Received: by mail-qk0-f193.google.com with SMTP id k74so2900009qke.2
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2017 11:49:13 -0700 (PDT)
In-Reply-To: <73cdc776-8eea-b63b-89af-ffa9829e1f9d@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, linux-nvme@lists.infradead.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>, raphasil@linux.vnet.ibm.com, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

On 5/16/2017 5:26 AM, Guilherme G. Piccoli wrote:
> On 05/15/2017 07:20 PM, James Smart wrote:
>> The driver panic when using the els_wq during port reset.
>>
>> Check for NULL els_wq before dereferencing.
>
> James/Dick, if possible please take a look on:
> https://marc.info/?l=linux-scsi&m=149487670315697
>
> For some reason that email didn't get threaded as I expect. And also I
> forgot to include James' Gmail address, sorry.
>
> Thanks in advance,
>
>
> Guilherme

Gilherme,

Your patch is still needed.  Can you repost your patch with a new 
subject and add my signature:

Signed-off-by: James Smart <james.smart@broadcom.com>

Sorry, I didn't see it to roll it into the set.

-- james
