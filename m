From: walt <w41ter@gmail.com>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Date: Tue, 07 Jan 2014 11:15:40 -0800
Message-ID: <52CC525C.5060900@gmail.com>
References: <20131218211219.461663463@linuxfoundation.org> <20131218211220.412278148@linuxfoundation.org> <52C32BB0.90600@gmail.com> <20140102191510.GA9621@xanatos> <52C6D9F1.9000709@gmail.com> <20140103195455.GA4193@xanatos> <52C729CE.9050307@gmail.com> <20140103232929.GD4193@xanatos> <20140107003157.GA7963@xanatos> <52CC014C.5060604@gmail.com> <063D6719AE5E284EB5DD2968C1650D6D453E1A@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:54469 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaAGTPm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jan 2014 14:15:42 -0500
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D453E1A@AcuExch.aculab.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Laight <David.Laight@ACULAB.COM>, Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/07/2014 05:58 AM, David Laight wrote:
> The dmesg contains:
> 
> [  538.728064] EXT4-fs warning (device dm-0): ext4_end_bio:316: I/O error writing to inode 23330865 (offset 0 size 8388608 starting block 812628)
> 
> An 8MB transfer will need at least 128 ring entries (TRB) even if the request
> is a single contiguous memory block.
> 
> Are you using the patch that increases the ring size from 64 to 256?

Yes, 256.  I'll work on getting more debugging output.

