From: Zheng Da <zhengda1936@gmail.com>
Subject: Re: interrupt coalescing in LSI HBA controller
Date: Mon, 17 Jun 2013 16:34:04 -0400
Message-ID: <CAFLer81rKuzvKGqA-7kktMdRzsJ-08T8e9qZTNoQQ7w=kAJVdw@mail.gmail.com>
References: <CAFLer81+p=-4NH5b6+VLSU6TcF-Vm_-FXKWhuUgzRgSOn3WCGA@mail.gmail.com>
 <CAC9+an+3P29pZ-hXAF31mgCeRT5iypLeWfi_Qf5cFTJrJ_cWHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:56407 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab3FQUeZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jun 2013 16:34:25 -0400
Received: by mail-bk0-f53.google.com with SMTP id e11so1405471bkh.40
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2013 13:34:24 -0700 (PDT)
In-Reply-To: <CAC9+an+3P29pZ-hXAF31mgCeRT5iypLeWfi_Qf5cFTJrJ_cWHw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baruch Even <baruch@ev-en.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hello,

I have tried lsiutil and it cannot recognize the LSI controllers. I
have talked to the LSI tech support and they told me that lsiutil
doesn't support this type of HBA controllers.
I found lsiutil in some other place. I couldn't find it in on LSI's
website. Do you know where I can download it from LSI's website?

Thanks,
Da

On Mon, Jun 17, 2013 at 2:44 PM, Baruch Even <baruch@ev-en.org> wrote:
> On Fri, Jun 14, 2013 at 7:44 PM, Zheng Da <zhengda1936@gmail.com> wrote:
>> Hello,
>>
>> First, I'm not very sure if this mailing list allows to ask technical
>> questions. I apologize if it's not a right place to ask questions.
>>
>> I use one LSI SAS 9207-8e controllers to attach 8 SSDs to my server.
>> They together can deliver over 300,000 IO per second. I use mpt2sas
>> driver and MPI-X is enabled. In order to handle so many IOs, I assign
>> different IRQs to different CPU cores.
>>
>> I see very high CPU consumption, so I hope to enable interrupt
>> coalescing to reduce CPU consumption. I monitored interrupts by using
>> systemtap to count the number of invocations of handle_irq, and found
>> the number of interrupts delivered by the LSI HBA is more or less the
>> same as the number of IOs performed on the SSDs. I assume interrupt
>> coalescing doesn't work in my case.
>>
>> If so, how do I enable interrupt coalescing in the LSI HBA. I checked
>> all mpt2sas parameters and none of them are used to control it. The
>> tool lsiutil doesn't work for this controller. I'm pretty sure the LSI
>> HBA supports interrupt coalescing. Do I have to use some special
>> configuration (the Linux kernel or hardware) in order to make it work?
>
> lsiutil will enable you to read and control the interrupt coalescing on the hba.
> It should be possible to find it on lsi's website.
>
> Baruch
