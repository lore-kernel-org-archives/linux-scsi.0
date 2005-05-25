From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [ANNOUNCE] sdparm 0.92
Date: Wed, 25 May 2005 11:40:40 +1000
Message-ID: <4293D798.4020606@torque.net>
References: <428DC633.5050403@torque.net> <4293BD80.1050503@danbbs.dk>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:62640 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262233AbVEYBke (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 21:40:34 -0400
In-Reply-To: <4293BD80.1050503@danbbs.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: monz@danbbs.dk
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com

Mogens Valentin wrote:
> Douglas Gilbert wrote:
> 
>> sdparm is a command line utility designed to get and set
>> SCSI disk parameters (cf hdparm for ATA disks). More generally
>> it gets and sets mode page information on SCSI devices or devices
>> that use a SCSI command set (e.g. CD/DVD drives (any transport)
>> and SCSI tape drives). It also can list VPD pages including
>> the device identification page.
>>
>> For more information and downloads (tarball, rpm and deb
>> packages) see:
>> http://www.torque.net/sg/sdparm.html
> 
> 
> Nice! Just got it and tried on an external usb disk.
> One feature I could use, probably others as well:
> Could you add the ability to spin down/up a scsi disk?
> I'd really like this for exteral (usb) disks.

Mogens,
With sg_start (in the sg3_utils package) I have tried
to spin up and down an ATA disk inside a USB enclosure
without success. The same command on a USB connected
CD/DVD combo drive did work.

Could you try sg_start on your USB external enclosure
which I assume contains an ATA disk rather than a
SCSI (SPI) disk and report if it works?

BTW I just checked libata (for SATA disks) and it does
not seem to support the START STOP UNIT command.
Jeff, could that one be added?

> Doesn't seem it can; if I missed it, I'm sorry..

It is hard to know where to stop with sdparm ;-)
At the moment I am adding transport (protocol) specific
mode page support. So currently sdparm specializes
in mode pages (for all SCSI command sets) and INQUIRY
information (including the device identification VPD
page).

Doug Gilbert

