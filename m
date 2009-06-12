From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Return of PENDING status to SCSI driver
Date: Fri, 12 Jun 2009 07:32:56 -0400
Message-ID: <4A323CE8.7010207@garzik.org>
References: <3e7aae30906120229p3bbeb7f0jd07c5f1e823a456a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:49585 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbZFLLc5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jun 2009 07:32:57 -0400
In-Reply-To: <3e7aae30906120229p3bbeb7f0jd07c5f1e823a456a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ramya Desai <ramya.desai@gmail.com>
Cc: linux-scsi@vger.kernel.org

Ramya Desai wrote:
> Dear Experts,
> 
> I am writing my mass storage class driver for my custom USB device.
> My device is capable of queuing the commands that are issued to it.
> So, I wanted to send the second command from my driver even before the
> completion of first command.
> To do this I wanted to return the PENDING status to the SCSI layer
> immediately after receiving the command.

Simply queue as many commands as possible to your hardware, and complete 
them when they are done.  Use can_queue or scsi_adjust_queue_depth() to 
set queueing limits.

	Jeff



