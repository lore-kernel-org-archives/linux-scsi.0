From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] 2.6.9-rc4mm1:badness in drivers/scsi/scsi_lib.c
Date: Thu, 21 Oct 2004 10:41:35 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0410211039420.2736-100000@ida.rowland.org>
References: <Pine.GSO.4.58.0410211123290.5705@boromir>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:10500 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S270715AbUJUOlk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 10:41:40 -0400
In-Reply-To: <Pine.GSO.4.58.0410211123290.5705@boromir>
List-Id: linux-scsi@vger.kernel.org
To: Mateusz.Blaszczyk@nask.pl
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Thu, 21 Oct 2004 Mateusz.Blaszczyk@nask.pl wrote:

> > > After successful write on USB DVD-R writer (HP-200j), system oops's when unpluging USB device.
> > > Same thing with 2.6.9-rc2mm1.
> >
> > Try applying this patch:
> >
> > http://marc.theaimsgroup.com/?l=linux-usb-devel&m=109744234829347&q=raw
> 
> Patch applied.
> I have done the tests at still no good.
> I connected and disconnected the writer a couple of times. WHen I didn't
> read/write on the CD there is no OOPS when disconnecting. But after reading CD
> there was OOPS when disconnecting. See below. Decoded OOPS - see more below.

Can you turn on the usb-storage verbose debugging option in the kernel 
configuration and then try running your test over again?  Be sure also to 
set up /etc/syslog.conf to capture debug-level kernel messages.

Alan Stern

