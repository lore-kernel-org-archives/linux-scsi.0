From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: how to firing device event when SD card inserting usb card reader
Date: Thu, 26 Jun 2014 11:57:26 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1406261157000.953-100000@iolanthe.rowland.org>
References: <CANudz+tSTQLOQpNx71+h+cCUnoEshiCyDe+e=9E_ajvoj3a8Dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:38031 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755487AbaFZP52 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jun 2014 11:57:28 -0400
In-Reply-To: <CANudz+tSTQLOQpNx71+h+cCUnoEshiCyDe+e=9E_ajvoj3a8Dg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: loody <miloody@gmail.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Thu, 26 Jun 2014, loody wrote:

> hi all:
> I try below flow:
> 1. plug in usb card reader
> 2. wait 2 seconds
> 3. plug in SD card
> 
> on ubuntu PC system, the udev can get SD plug in event
> but on my embedded system, there is no udev plug event when SD plug in.
> 
> Is this issue related to media change command?
> if so, should I enable kernel config or do anything in user mode program?
> 
> thanks for your help in advance,

What does usbmon show?

Alan Stern

