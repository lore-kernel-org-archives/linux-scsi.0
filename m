From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Questions about the midlevel scsi subsystem
Date: 08 Jun 2002 01:04:58 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1023494698.27909.0.camel@irongate.swansea.linux.org.uk>
References: <Pine.LNX.4.33L2.0206061145520.857-100000@ida.rowland.org>
	<20020607153918.A8319@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020607153918.A8319@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Alan Stern <stern@rowland.org>, linux-scsi@vger.kernel.org, Matthew Dharm <mdharm-usb@one-eyed-alien.net>

On Fri, 2002-06-07 at 23:39, Patrick Mansfield wrote:
> The mid-layer should never send more than can_queue comands to
> the low-level driver, that would be a bug.

The old scsi_eh code used to occasionally do this. I don't know if it
was ever properly fixed. So if you do think you are seeing it off by
one, double check your counts but if your counts show the kernel is a
bit out suspect the mid layer too

