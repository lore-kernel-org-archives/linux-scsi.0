From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH RESEND 1/18] megaraid_sas : Add separate function for
 setting up IRQs
Date: Tue, 21 Apr 2015 17:11:02 +0530
Message-ID: <8fe11fb76ad331a41f83121fb704f939@mail.gmail.com>
References: <201504201234.t3KCYg04016312@palmhbs0.lsi.com> <20150421103330.GA8920@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:32788 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbbDULlE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2015 07:41:04 -0400
Received: by qgdy78 with SMTP id y78so66640423qgd.0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2015 04:41:03 -0700 (PDT)
In-Reply-To: <20150421103330.GA8920@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>

>-----Original Message-----
>From: Christoph Hellwig [mailto:hch@infradead.org]
>Sent: Tuesday, April 21, 2015 4:04 PM
>To: Sumit.Saxena@avagotech.com
>Cc: linux-scsi@vger.kernel.org; thenzl@redhat.com;
>martin.petersen@oracle.com; hch@infradead.org;
>jbottomley@parallels.com; kashyap.desai@avagotech.com
>Subject: Re: [PATCH RESEND 1/18] megaraid_sas : Add separate function for
>setting up IRQs
>
>On Mon, Apr 20, 2015 at 06:02:30PM +0530, Sumit.Saxena@avagotech.com
>wrote:
>> This patch will create separate function for setting up IRQs and enable
>interrupts after adapter's initialization.
>
>The structure of megasas_setup_irqs clearly suggest it should be two
>functions: one for the traditional case, and one for MSI-X.
>
>The irq unregister case should get a similar factoring.

Ok, I will create separate functions for setup_irqs- one for MSI-x and one
for traditional case. Will refactor to create separate function for
freeing IRQs.
>
>Additionally the changelog needs an explanation on why you move around
>the code that registeres interrupts as well as the
>->instancet->enable_intr call.
Will resend the patch with explanation and three new functions(MSI-x
setup, IO_APIC setup and freeing IRQs) added.
