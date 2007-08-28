From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb-storage and Motorola Z6
Date: Tue, 28 Aug 2007 16:45:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0708281641480.6734-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-users-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-users>
List-Post: <mailto:linux-usb-users@lists.sourceforge.net>
List-Help: <mailto:linux-usb-users-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-users-bounces@lists.sourceforge.net
Errors-To: linux-usb-users-bounces@lists.sourceforge.net
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Andreas Koenecke <akoenecke@akoenecke.de>, USB users list <linux-usb-users@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

Can any SCSI experts explain what's going wrong here?

Alan Stern


---------- Forwarded message ----------
Date: Tue, 28 Aug 2007 22:13:16 +0200
From: Andreas Koenecke <akoenecke@akoenecke.de>
To: USB users list <linux-usb-users@lists.sourceforge.net>
Cc: akoenecke@akoencke.de
Subject: Re: [Linux-usb-users] usb-storage and Motorola Z6

* Dienstag, 28. August 2007 um 15:13 (-0400) schrieb Alan Stern:
> 
> > > Aug 28 09:54:33 kocom kernel: usb-storage: device scan complete
> > >
> > > Aug 28 09:54:33 kocom kernel: scsi 4:0:0:0: Direct-Access     Motorola MSnc.
> > >  PQ: 1 ANSI: 0 CCS
> > >
> > > Aug 28 09:54:33 kocom kernel: scsi 4:0:0:1: Direct-Access     Motorola MSnc.
> > >  PQ: 1 ANSI: 0 CCS
> > >
> > > Aug 28 09:54:33 kocom kernel: scsi 4:0:0:0: Attached scsi generic sg2 type 0
> > >
> > > Aug 28 09:54:33 kocom kernel: scsi 4:0:0:1: Attached scsi generic sg3 type 0
> > >
> > > Aug 28 10:02:47 kocom kernel: usb 3-1: USB disconnect, address 5
> > > ---------------------------------------------------------------------------------
> 
> Everything looks correct except that sd_mod isn't loaded.

sd_mod is build fix into the kernel because of the real SCSI card. All other
usb-storage devices (flash sticks, card reader and USB HDDs) are working
without problems.

I connected the phone to a complete different computer (my laptop: vendor
kernel, more modularized) and sd_mod is loading when I plug in, but
nevertheless no block-devices. The same behavior as on my desktop computer...
 

Andreas


-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
_______________________________________________
Linux-usb-users@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-users
