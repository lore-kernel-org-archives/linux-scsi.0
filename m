From: "Eric Pesciotta" <EPesciotta@TTCDAS.com>
Subject: RE: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b4).
Date: Fri, 14 Jan 2005 15:24:14 -0500
Message-ID: <71C7B3642712E545B13B00D7D6D642E206639F@exchange.ttcdas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exchange.ttcdas.com ([67.109.153.70]:4451 "EHLO
	exchange.ttcdas.com") by vger.kernel.org with ESMTP id S262149AbVANU0Z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jan 2005 15:26:25 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-Scsi (E-mail)" <linux-scsi@vger.kernel.org>

I apologize in advance for the flash back.

>From Andrew Vasquez' reply on 2003-07-18 21:46:19 to Christoph Hellwig's comments
>>  - in qla2x00_queuecommand you need to call
>>   spin_unlock_irq/spin_lock_irq on the hostlock, otherwise your whole
>>  ->queuecommand runs with (local) interrupts disabled
>
>Noted..

The qla2x00 7.03.00 driver has exactly the same problem.
Is it safe to change qla2x00_queuecommand from spin_unlock(&io_request_lock) to spin_unlock_irq(&io_request_lock) in a 2.4 kernel?

-ejp-
