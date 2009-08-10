From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Bugs in scsi_vpd_inquiry()
Date: Mon, 10 Aug 2009 17:53:51 -0400
Message-ID: <4A8096EF.6010508@interlog.com>
References: <Pine.LNX.4.44L0.0908101119460.3208-100000@iolanthe.rowland.org> <yq17hxbfvf9.fsf@sermon.lab.mkp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:48105 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939AbZHJVxy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Aug 2009 17:53:54 -0400
In-Reply-To: <yq17hxbfvf9.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>, SCSI development list <linux-scsi@vger.kernel.org>

Martin K. Petersen wrote:
>>>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:
> 
> Alan,
> 
>>>> data always to be accurate may not be a good idea.  I'm considering
>>>> adding a "restrict_to_MS_usb" flag to the host template, to
>>>> indicate that commands shouldn't be sent unless some version of
>>>> Windows uses them when talking to USB devices -- do you think that
>>>> could work?
>>> Not really my area of expertise.
> 
> Alan> Okay.  Maybe Martin has some thoughts on it.
> 
> First of all we're not going to send EVPD=1 out to devices reporting
> SCSI_SPC_2 or lower anymore, making some of this discussion moot in the
> short term.
> 
> But as I have alluded to in the past we do have a conflict brewing
> because the switch to drives with 4KB physical blocks will mean USB
> bridges will have to get smarter.  And that in turn will mean adhering
> (*gasp*) to the standard instead of firmware writers flipping bits until
> Windows stops crashing.  Windows 7 does in fact query drives about
> alignment, block sizes, etc.  But I'm not sure how true that is for the
> Windows USB storage stack.

It would be interesting to know if Windows 7 is pushing
UAS (USB attached SCSI) [latest draft at www.t10.org is
uas-r02.pdf].

"USB Attached SCSI is a new generation of USB Transport
  Standards. This standard supports the following
  features in support of USB-20 and future USB
  specifications:
     a)  does not interfere with the USB Mass Storage Class
         (MSC) bulk-only transport;
     b)  mechanism to send commands associated with any T10
         standard to a USB device;
     c)  support for queuing in the protocol;
     d)  support for autosense;
     e)  compliance with SCSI Architecture Model - 4 (SAM-4)
         or later; and
     f)  other capabilities."

It is at the letter ballot stage at t10.


Doug Gilbert


