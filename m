From: Zheng Da <zhengda1936@gmail.com>
Subject: interrupt coalescing in LSI HBA controller
Date: Fri, 14 Jun 2013 12:44:31 -0400
Message-ID: <CAFLer81+p=-4NH5b6+VLSU6TcF-Vm_-FXKWhuUgzRgSOn3WCGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:57344 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3FNQox (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jun 2013 12:44:53 -0400
Received: by mail-bk0-f54.google.com with SMTP id it16so367528bkc.27
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jun 2013 09:44:51 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

First, I'm not very sure if this mailing list allows to ask technical
questions. I apologize if it's not a right place to ask questions.

I use one LSI SAS 9207-8e controllers to attach 8 SSDs to my server.
They together can deliver over 300,000 IO per second. I use mpt2sas
driver and MPI-X is enabled. In order to handle so many IOs, I assign
different IRQs to different CPU cores.

I see very high CPU consumption, so I hope to enable interrupt
coalescing to reduce CPU consumption. I monitored interrupts by using
systemtap to count the number of invocations of handle_irq, and found
the number of interrupts delivered by the LSI HBA is more or less the
same as the number of IOs performed on the SSDs. I assume interrupt
coalescing doesn't work in my case.

If so, how do I enable interrupt coalescing in the LSI HBA. I checked
all mpt2sas parameters and none of them are used to control it. The
tool lsiutil doesn't work for this controller. I'm pretty sure the LSI
HBA supports interrupt coalescing. Do I have to use some special
configuration (the Linux kernel or hardware) in order to make it work?

Thanks,
Da
