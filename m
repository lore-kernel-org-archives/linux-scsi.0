From: =?UTF-8?B?UGV0ZXIgUGFsw7pjaA==?= <Peter.Paluch@fri.uniza.sk>
Subject: Re: XHCI issues: WD MyBook 1230 - reset SuperSpeed USB device
Date: Sat, 18 Jan 2014 16:02:28 +0100
Message-ID: <52DA9784.3090507@fri.uniza.sk>
References: <Pine.LNX.4.44L0.1401161532560.1109-100000@iolanthe.rowland.org> <52D8DD45.9010602@suse.de> <52D991BA.40903@interlog.com> <52D99D51.1030100@fri.uniza.sk> <52DA8BCF.6070201@t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from castor.kis.fri.uniza.sk ([158.193.152.2]:38667 "EHLO
	mail.kis.fri.uniza.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaARPCe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2014 10:02:34 -0500
In-Reply-To: <52DA8BCF.6070201@t-online.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christian Franke <Christian.Franke@t-online.de>, dgilbert@interlog.com
Cc: Hannes Reinecke <hare@suse.de>, Alan Stern <stern@rowland.harvard.edu>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

Christian,

>> Douglas, Hannes: I believe we are definitely on to something. I do 
>> _not_ run smartd but this may be caused by something in my Gnome3 GUI 
>> environment. I have noticed that when I am not logged in to Gnome and 
>> work just in the text console, plugging in the USB drive and 
>> accessing it works without any issues. Only when I am logged into my 
>> Gnome and plug the drive in, Gnome obviously tries to do something 
>> with the drive that causes it to stall and recover in 30 seconds. I 
>> have not yet been able to identify what it is.
>
> Gnome disk utility?
>
> AFAIK it relies on libatasmart. The source code of libatasmart is 
> unrelated to smartmontools.

I am not intentionally starting or running any disk utility when 
plugging the USB disk to my notebook. I am simply logged to Gnome3, have 
my terminal window open, plug in the disk - and voila, I can be sure 
that within 30 seconds, I get a dmesg log about the drive being reset, 
without even calling the gdisk utility I've been using earlier (note - 
no change of behavior here, it was just me trying to work with the drive 
right after it was recognized, which obviously coincided with some Gnome 
subsystem trying to lay its hands on the drive as well - perhaps the 
automount, udisksd, or something else). I will try to find out what 
exactly is fired up in Gnome when I plug in the drive, and will update 
this thread as soon as I have something new.

Best regards,
Peter

