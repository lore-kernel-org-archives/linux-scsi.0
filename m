From: Steve Magnani <steve.magnani@digidescorp.com>
Subject: Re: READ_CAPACITY_16 vs. READ_CAPACITY_10
Date: Wed, 11 Sep 2013 10:56:36 -0500
Message-ID: <1378914996.1888.38.camel@iscandar.digidescorp.com>
References: <Pine.LNX.4.44L0.1309111140240.1352-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:40287 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab3IKP4j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Sep 2013 11:56:39 -0400
Received: by mail-ob0-f179.google.com with SMTP id fb19so8497371obc.38
        for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2013 08:56:38 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.44L0.1309111140240.1352-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>, hare@suse.de, linux-scsi@vger.kernel.org

On Wed, 2013-09-11 at 11:42 -0400, Alan Stern wrote: 
> On Wed, 11 Sep 2013, Oliver Neukum wrote:
> > 
> > I'll try to get a Windows machine for a trace.
> > Can you suggest a tracer for Win7?
> 
> I don't know of any, offhand.  Maybe Google can help.
> 
> Alternatively, you could install Windows 7 in a virtual machine under 
> Linux and use usbmon.

USBPcap can capture Windows USB transactions which Wireshark 1.10 or
later can interpret:
http://desowin.org/usbpcap/ 
Note, if you're used to WinPCap or usbmon capture integration with
Wireshark this will be an adjustment. You have to run USBPcap from the
command line to do the capture to a file, quit the capture, then open
the file in Wireshark.

I think depending on the options you pass to USBPcap you could end up
with .pcap frames that are larger than Wireshark can handle (i.e., for a
READ(x) transfer of 128 blocks).

Regards,
------------------------------------------------------------------------
Steven J. Magnani               "I claim this network for MARS!
www.digidescorp.com              Earthling, return my space modulator!"

#include <standard.disclaimer>


