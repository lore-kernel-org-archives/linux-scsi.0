From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] 2.6.9-rc4mm1:badness in drivers/scsi/scsi_lib.c
Date: Tue, 26 Oct 2004 11:07:46 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0410261106430.1300-100000@ida.rowland.org>
References: <Pine.GSO.4.58.0410260947280.22299@boromir>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:8452 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262289AbUJZPHq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 11:07:46 -0400
In-Reply-To: <Pine.GSO.4.58.0410260947280.22299@boromir>
List-Id: linux-scsi@vger.kernel.org
To: Mateusz.Blaszczyk@nask.pl
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB development list <linux-usb-devel@lists.sourceforge.net>

On Tue, 26 Oct 2004 Mateusz.Blaszczyk@nask.pl wrote:

> Well, I think I must admit I was wrong.
> 
> I have done some tests and there was no ooops after succesful writing or after
> unmounting device. The oops is when I unplug USB-DVD-Recorder when there is
> already mounted device on it.
> 
> Then there is state transition from NULL->cancel and kernel oops!
> See oops and decoded oops below:

Maybe James will be able to figure out the problem.

> I noticed other thing. When I plug and unplug device, DVD-Recorder is seen on a
> new scsi bus number, starting from 0. Is it ok?

This patch should fix that:

http://marc.theaimsgroup.com/?l=linux-scsi&m=109863610814850&w=2

Alan Stern

