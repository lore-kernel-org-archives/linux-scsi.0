From: Joel Stanley <joel@jms.id.au>
Subject: Re: [PATCH] be2iscsi: Fix bad WARN_ON
Date: Fri, 2 Oct 2015 10:22:01 +0930
Message-ID: <CACPK8XfROyJM_nuZdLEY49HZH+arQjqCmqiKNo+821gMPvCxMQ@mail.gmail.com>
References: <1443686578-13030-1-git-send-email-joel@jms.id.au> <mqdh9mbm1l5.fsf@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:33386 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbbJBAwV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2015 20:52:21 -0400
Received: by obbbh8 with SMTP id bh8so71344986obb.0
        for <linux-scsi@vger.kernel.org>; Thu, 01 Oct 2015 17:52:21 -0700 (PDT)
In-Reply-To: <mqdh9mbm1l5.fsf@c203.arch.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: jayamohan.kallickal@avagotech.com, minh.tran@avagotech.com, sony.john-n@avagotech.com, JBottomley@odin.com, linux-scsi@vger.kernel.org

On Thu, Oct 1, 2015 at 6:01 PM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
>> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
>> index 7a6dbfb..0b87abb 100644
>> --- a/drivers/scsi/be2iscsi/be_main.c
>> +++ b/drivers/scsi/be2iscsi/be_main.c
>> @@ -3184,7 +3184,7 @@ be_sgl_create_contiguous(void *virtual_address,
>>  {
>>       WARN_ON(!virtual_address);
>>       WARN_ON(!physical_address);
>> -     WARN_ON(!length > 0);
>> +     WARN_ON(!(length > 0));
>
> Why aren't you doing WARN_ON(length <= 0); it's much nicer to read IMHO

Sure, I'll resend.
