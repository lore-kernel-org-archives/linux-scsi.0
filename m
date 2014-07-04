From: loody <miloody@gmail.com>
Subject: Re: how to firing device event when SD card inserting usb card reader
Date: Fri, 4 Jul 2014 19:23:22 +0800
Message-ID: <CANudz+tjtqA=OEWdBymec1U+b9vhcYt+ry=XM=XR7ZohVALLDg@mail.gmail.com>
References: <CANudz+tSTQLOQpNx71+h+cCUnoEshiCyDe+e=9E_ajvoj3a8Dg@mail.gmail.com>
	<Pine.LNX.4.44L0.1406261157000.953-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36481 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbaGDLXY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2014 07:23:24 -0400
In-Reply-To: <Pine.LNX.4.44L0.1406261157000.953-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

hi Alan:

2014-06-26 23:57 GMT+08:00 Alan Stern <stern@rowland.harvard.edu>:
> On Thu, 26 Jun 2014, loody wrote:
>
>> hi all:
>> I try below flow:
>> 1. plug in usb card reader
>> 2. wait 2 seconds
>> 3. plug in SD card
>>
>> on ubuntu PC system, the udev can get SD plug in event
>> but on my embedded system, there is no udev plug event when SD plug in.
>>
>> Is this issue related to media change command?
>> if so, should I enable kernel config or do anything in user mode program?
>>
>> thanks for your help in advance,
>
> What does usbmon show?
after we enable CONFIG_SCSI_MULTI_LUN, we can udevent when SD plug in
card reader.

appreciate your kind help,
