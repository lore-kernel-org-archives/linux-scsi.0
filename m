From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Asynchronous Mass storage driver
Date: Wed, 24 Jun 2009 15:06:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0906241504370.4106-100000@iolanthe.rowland.org>
References: <3e7aae30906240910p18cc23e9v10e5cf5b7b6cd91a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55810 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751969AbZFXTGU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2009 15:06:20 -0400
In-Reply-To: <3e7aae30906240910p18cc23e9v10e5cf5b7b6cd91a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ramya Desai <ramya.desai@gmail.com>
Cc: USB list <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org

On Wed, 24 Jun 2009, Ramya Desai wrote:

> Dear Experts,
> 
> I am trying to develop an asynchronous mass storage driver for my custom device.
> I am using the default mass storage driver as my basis.
> 
> My first question, is the completion routine the first one to be
> called if the request finishes?

Are you talking about USB requests (i.e., URBs) and USB completion 
routines?  Then the answer is yes.

> I wanted to my command submit to USB stack (submitURB()) code in the
> driver context and look for the another command from the upper layer.
> To do so I wanted to move the rest of the code to completion routine.
> If I return USB_STOR_TRANSPORT_GOOD in completion routine, where this
> return is going to?

USB completion routines always return void.  You cannot return 
USB_STOR_TRANSPORT_GOOD from a completion routine.

> Is there any Asynchronous mass storage reference code available?

drivers/block/ub.c.

Alan Stern

