From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb-storage/SCSI: Add broken_fua blacklist flag
Date: Sat, 26 Jul 2014 21:50:51 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1407262149370.20700-100000@netrider.rowland.org>
References: <CAOaU5MZxg4eFsFO51fkCqx_HLAi=TcZKqdJ8RAOL4F+iU50RkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:57711 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751315AbaG0Buw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Jul 2014 21:50:52 -0400
In-Reply-To: <CAOaU5MZxg4eFsFO51fkCqx_HLAi=TcZKqdJ8RAOL4F+iU50RkA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Laszlo T." <tlacix@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Sat, 26 Jul 2014, Laszlo T. wrote:

> Hello,
> 
> First of all I've just subscribed the linux-scsi thread. I hope you
> get my email the right way.
> 
> I have also problems with Jmicron JMS567 mobile rack.
> 
> I tried on different kernels:
> 3.15.5
> 3.16.rc6
> the 'Invalid field in cdb' errors disappeared but still not ok.

Since your device uses the uas driver, you might get more help on the 
linux-usb mailing list.  (You don't have to subscribe to the list in 
order to post to it.)

Alan Stern

