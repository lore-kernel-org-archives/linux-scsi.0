From: Baruch Even <baruch@ev-en.org>
Subject: Re: interrupt coalescing in LSI HBA controller
Date: Mon, 17 Jun 2013 21:44:01 +0300
Message-ID: <CAC9+an+3P29pZ-hXAF31mgCeRT5iypLeWfi_Qf5cFTJrJ_cWHw@mail.gmail.com>
References: <CAFLer81+p=-4NH5b6+VLSU6TcF-Vm_-FXKWhuUgzRgSOn3WCGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:50883 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3FQSoX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jun 2013 14:44:23 -0400
Received: by mail-ea0-f172.google.com with SMTP id q10so2065178eaj.31
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jun 2013 11:44:22 -0700 (PDT)
In-Reply-To: <CAFLer81+p=-4NH5b6+VLSU6TcF-Vm_-FXKWhuUgzRgSOn3WCGA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zheng Da <zhengda1936@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Jun 14, 2013 at 7:44 PM, Zheng Da <zhengda1936@gmail.com> wrote:
> Hello,
>
> First, I'm not very sure if this mailing list allows to ask technical
> questions. I apologize if it's not a right place to ask questions.
>
> I use one LSI SAS 9207-8e controllers to attach 8 SSDs to my server.
> They together can deliver over 300,000 IO per second. I use mpt2sas
> driver and MPI-X is enabled. In order to handle so many IOs, I assign
> different IRQs to different CPU cores.
>
> I see very high CPU consumption, so I hope to enable interrupt
> coalescing to reduce CPU consumption. I monitored interrupts by using
> systemtap to count the number of invocations of handle_irq, and found
> the number of interrupts delivered by the LSI HBA is more or less the
> same as the number of IOs performed on the SSDs. I assume interrupt
> coalescing doesn't work in my case.
>
> If so, how do I enable interrupt coalescing in the LSI HBA. I checked
> all mpt2sas parameters and none of them are used to control it. The
> tool lsiutil doesn't work for this controller. I'm pretty sure the LSI
> HBA supports interrupt coalescing. Do I have to use some special
> configuration (the Linux kernel or hardware) in order to make it work?

lsiutil will enable you to read and control the interrupt coalescing on the hba.
It should be possible to find it on lsi's website.

Baruch
