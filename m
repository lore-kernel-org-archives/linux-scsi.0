From: Minwoo Im <dn3108@gmail.com>
Subject: Re: [PATCH] scsi_proto.h: ATA_32 added for ata pass-thru(32).
Date: Sat, 17 Jun 2017 15:48:42 +0900
Message-ID: <CAKv8XUXNuAcw6GsQv+Cm+h2kSnbxWZ3ZCiSR4-oa3wevxXCjaA@mail.gmail.com>
References: <1497526164-7432-1-git-send-email-dn3108@gmail.com> <1497626842.2621.7.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:34174 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbdFQGtY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Jun 2017 02:49:24 -0400
Received: by mail-yw0-f195.google.com with SMTP id w143so3701348yww.1
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jun 2017 23:49:23 -0700 (PDT)
In-Reply-To: <1497626842.2621.7.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sat, Jun 17, 2017 at 12:27 AM, Bart Van Assche
<Bart.VanAssche@wdc.com> wrote:
> On Thu, 2017-06-15 at 20:29 +0900, Minwoo Im wrote:
>> SAT-4(SCSI/ATA Translation Standard) supports a ATA PASS-THROUGH(32)
>> SCSI command. It uses 7Fh as a operation code which means
>> variable-length CDB.
>> It would be great if kernel supports an ata pass-thru(32) command.
>> Prior to development of ata pass-through in libata level,
>> the definition of it should be added first.
>>
>> Signed-off-by: Minwoo Im <dn3108@gmail.com>
>> ---
>>  include/scsi/scsi_proto.h |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
>> index ce78ec8..1eb4efd 100644
>> --- a/include/scsi/scsi_proto.h
>> +++ b/include/scsi/scsi_proto.h
>> @@ -164,6 +164,7 @@
>>  #define WRITE_SAME_32              0x0d
>>
>>  /* Values for T10/04-262r7 */
>> +#define      ATA_32                0x7F      /* 32-byte pass-thru */
>>  #define      ATA_16                0x85      /* 16-byte pass-thru */
>>  #define      ATA_12                0xa1      /* 12-byte pass-thru */
>
> Hello Minwoo,
>
> In the Linux kernel we do not add such definitions separately but we
> only add such definitions together with the code that uses the newly
> introduced symbolic name.
>
> Regarding the above patch, to keep the definitions consistent, please
> use VARIABLE_LENGTH_CMD as a symbolic name for 0x7F and also add the
> following definition below "/* values for variable length command */":
>
> #define ATA_32 0x1ff0
>
> Thanks,
>
> Bart.

(retry to reply in plain text mode)

Dear Bart,

First of all, I really appreciate letting me know the part of process
of kernel development. I completely agree with you about the
VARIABLE_LENGTH_CMD symbolic name because it's not only for
ATA PASS-THROUGH(32) command.

I'll try to send a patch the ATA_32 with codes that use those
symbolic names soon.

Thanks, again


Minwoo.
