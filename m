From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [Ubuntu PATCH] 3w-9xyz: add proc_name
Date: Wed, 21 Jun 2006 13:50:08 -0700
Message-ID: <4499B100.6010309@oracle.com>
References: <4498D9EA.5090909@oracle.com> <b1bc6a000606211123h598ff564i5b8a25bb92e19a00@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:36833 "EHLO
	rgminet01.oracle.com") by vger.kernel.org with ESMTP
	id S932278AbWFUUsu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 16:48:50 -0400
In-Reply-To: <b1bc6a000606211123h598ff564i5b8a25bb92e19a00@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>, jejb <James.Bottomley@steeleye.com>, linuxraid@amcc.com

adam radford wrote:
> Randy,
> 
> Is there any reason why any of these proc_name patches need to
> go in after James Smart's explanation:

Nope.  Thanks for your comments.

~Randy

> http://marc.theaimsgroup.com/?l=linux-scsi&m=115040210406375&w=2
> 
> in particular, the part about:
> 
> "- scsi_proc_hostdir_add() validates that sht->proc_info is non-null before
>   attempting to use sht->proc_name."
> 
> proc_info is null for the 3w-9xxx driver.
> 
> -Adam
> 
> On 6/20/06, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> Add .proc_name member to scsi_host_template for 3w-9xxx.
>>
>> http://www.kernel.org/git/?p=linux/kernel/git/bcollins/ubuntu-dapper.git;a=commitdiff;h=12fdf64086335ed596848cf17602e7a71e15ae9b
>>
>>
>>
>> ---
>>  drivers/scsi/3w-9xxx.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> --- linux-2617-pv.orig/drivers/scsi/3w-9xxx.c
>> +++ linux-2617-pv/drivers/scsi/3w-9xxx.c
>> @@ -2011,6 +2011,7 @@ static void twa_unmap_scsi_data(TW_Devic
>>  /* scsi_host_template initializer */
>>  static struct scsi_host_template driver_template = {
>>         .module                 = THIS_MODULE,
>> +       .proc_name              = "3w-9xxx",
>>         .name                   = "3ware 9000 Storage Controller",
>>         .queuecommand           = twa_scsi_queue,
>>         .eh_host_reset_handler  = twa_scsi_eh_reset,
>>
>>
>>
>> -

