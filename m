From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH-v1 00/22] lpfc updates for 11.2.0.12
Date: Fri, 21 Apr 2017 09:41:31 -0700
Message-ID: <08e8252e-826e-2560-7ae7-08253413fa96@broadcom.com>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
 <20170420183047.GD22378@kernel.dk> <20170421070027.GB26346@linux-x5ow.site>
 <yq1h91im2a8.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:35548 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1037491AbdDUQle (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 12:41:34 -0400
Received: by mail-oi0-f53.google.com with SMTP id j201so102598145oih.2
        for <linux-scsi@vger.kernel.org>; Fri, 21 Apr 2017 09:41:34 -0700 (PDT)
In-Reply-To: <yq1h91im2a8.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, jsmart2021@gmail.com, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me

On 4/21/2017 4:24 AM, Martin K. Petersen wrote:
> Johannes Thumshirn <jthumshirn@suse.de> writes:
>
>> Just for clarification, shouldn't Martin take the patches? They're for
>> drivers/scsi/lpfc/ after all. I just want to avoid confusion and possible
>> merge conflicts.
> Yeah, at this point I think it's better we do a second stage merge
> through 4.12/scsi-fixes. I'll set that up after Linus pulls from Jens.
>
no - most of the fixes are nvme related.  There are at best 3 that are 
"generic" or scsi specific.  Given the nvme parts need the nvme-fc api 
in the 2 dependencies... this won't be something that works well going 
through scsi.

-- james
