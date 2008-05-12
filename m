From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [2.6.25.1] QLA1040 Panic on startup
Date: Mon, 12 May 2008 16:59:10 -0500
Message-ID: <1210629550.3078.34.camel@localhost.localdomain>
References: <c457bfbf0805121437m355f2931p7d1a32fd5e40eb8e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:39988 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464AbYELV7O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2008 17:59:14 -0400
In-Reply-To: <c457bfbf0805121437m355f2931p7d1a32fd5e40eb8e@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sean bruno <seanwbruno@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2008-05-12 at 14:37 -0700, sean bruno wrote:
> qla1280: QLA1040 found on PCI bus 0, dev 6
> ACPI: Unable to derive IRQ for device 0000:00:06.0
> ACPI: PCI Interrupt 0000:00:06.0[A]: no GSI - using IRQ 11
> irq 11: nobody cared (try booting with the "irqpoll" option)

This looks a bit like an ACPI IRQ routing problem

Could you try booting with the kernel parameter

acpi=noirq

And see if that fixes it?

Thanks,

James


