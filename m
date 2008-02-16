From: Andrew Buehler <abuehler.kernel@gmail.com>
Subject: Re: USB regression (and other failures) in 2.6.2[45]*
Date: Sat, 16 Feb 2008 11:46:42 -0500
Message-ID: <47B71372.5050804@gmail.com>
References: <Pine.LNX.4.44L0.0802161013190.3769-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:36204 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbYBPQqu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Feb 2008 11:46:50 -0500
Received: by an-out-0708.google.com with SMTP id d31so239537and.103
        for <linux-scsi@vger.kernel.org>; Sat, 16 Feb 2008 08:46:48 -0800 (PST)
In-Reply-To: <Pine.LNX.4.44L0.0802161013190.3769-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

(Note: I consider it blatantly incorrect to send a reply both to a
mailing list and directly to the address of someone who is subscribed to
that list unless you have reason to believe that that someone will not
see the message otherwise, but in this case I am doing so anyway because
I see no way to avoid it and still make sure all relevant people receive
the message.)

On 2/16/2008 10:20 AM, Alan Stern wrote:

> On Sat, 16 Feb 2008, Oliver Pinter wrote:
> 
>> On 2/15/08, Andrew Buehler <abuehler.kernel@gmail.com> wrote:
>>> In my workplace, I use a customized version of Novell's ZENworks
>>> imaging boot CD, which is based off of Linux. I have one
>>> particular model of laptop - the IBM/Lenovo R61 - on which three
>>> different things fail completely in current kernels (tested with
>>> 2.6.24.2 and 2.6.25-rc1): USB, AHCI (and thus access to the SATA
>>> drive), and networking. As a consequence of all three failing in
>>> parallel, I have no practical way to get logs and other
>>> information off of the machine to help with tracking down the
>>> bugs.
> 
> ...
> 
> To make a long story short, the USB symptoms you describe indicate a
> problem with interrupt routing.  This could well explain the other
> difficulties too.  There are various kernel parameters you can try
> putting on the boot command line to work around it:  acpi=noirq or
> acpi=off or pci=noacpi or a few others.

I have now tried all three of these, with no apparent effect; the USB
drive is still not detected when plugged in after boot. A naive search
on Google provides no indication of other possible parameters to try;
the only list I have found of ACPI-related kernel parameters includes no
others which seem likely to be helpful without more knowledge of the
specifics of the situation (and the subsystem) than I have.

What would the next step be?

-- 
    Andrew Buehler
