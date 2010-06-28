From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Alternate ways to do Scatter-Gather from BOT Class driver
Date: Mon, 28 Jun 2010 14:55:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1006281452480.1977-100000@iolanthe.rowland.org>
References: <AANLkTiljLLGh8zbx1EY53-6LezDZ-utWW8FFbpFQwPIr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:38089 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751896Ab0F1Szb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2010 14:55:31 -0400
In-Reply-To: <AANLkTiljLLGh8zbx1EY53-6LezDZ-utWW8FFbpFQwPIr@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Subs <sar.subs@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 28 Jun 2010, Subs wrote:

> Hi All,
> 
> In my class driver I am receiving data transfer buffer as number of
> Scatter-Gather lists from SCSI layer to perform data transfers.
> 
> Is there any alternate way to get the transfer buffer from SCSI other
> than SG. I wanted to receive the complete data transfer buffer as a
> single pointer.

As far as I know, there is no alternate way to get the transfer buffer 
from the SCSI layer.

However you can get the effect you want by setting the sg_tablesize 
field in your scsi_host_template to 1.

Just out of curiosity, why are you writing a class driver for the BOT 
class?  Aren't the two existing drivers in the kernel good enough?

Alan Stern

