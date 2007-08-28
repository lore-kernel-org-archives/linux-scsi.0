From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: usb-storage and Motorola Z6
Date: Tue, 28 Aug 2007 14:48:31 -0600
Message-ID: <20070828204831.GL14130@parisc-linux.org>
References: <Pine.LNX.4.44L0.0708281641480.6734-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-users-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0708281641480.6734-100000@iolanthe.rowland.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-users>
List-Post: <mailto:linux-usb-users@lists.sourceforge.net>
List-Help: <mailto:linux-usb-users-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-users>,
	<mailto:linux-usb-users-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-users-bounces@lists.sourceforge.net
Errors-To: linux-usb-users-bounces@lists.sourceforge.net
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andreas Koenecke <akoenecke@akoenecke.de>, SCSI development list <linux-scsi@vger.kernel.org>, USB users list <linux-usb-users@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 28, 2007 at 04:45:59PM -0400, Alan Stern wrote:
> Can any SCSI experts explain what's going wrong here?

It's the PQ 1 -- the device is telling us that it's not actually there
right now.

> > > > Aug 28 09:54:33 kocom kernel: scsi 4:0:0:0: Direct-Access     Motorola MSnc.
> > > >  PQ: 1 ANSI: 0 CCS
> > > >
> > > > Aug 28 09:54:33 kocom kernel: scsi 4:0:0:1: Direct-Access     Motorola MSnc.
> > > >  PQ: 1 ANSI: 0 CCS
> > > >
> > > > Aug 28 09:54:33 kocom kernel: scsi 4:0:0:0: Attached scsi generic sg2 type 0
> > > >
> > > > Aug 28 09:54:33 kocom kernel: scsi 4:0:0:1: Attached scsi generic sg3 type 0
> > > >
> > > > Aug 28 10:02:47 kocom kernel: usb 3-1: USB disconnect, address 5
> > > > ---------------------------------------------------------------------------------
> > 
> > Everything looks correct except that sd_mod isn't loaded.
> 
> sd_mod is build fix into the kernel because of the real SCSI card. All other
> usb-storage devices (flash sticks, card reader and USB HDDs) are working
> without problems.
> 
> I connected the phone to a complete different computer (my laptop: vendor
> kernel, more modularized) and sd_mod is loading when I plug in, but
> nevertheless no block-devices. The same behavior as on my desktop computer...
>  
> 
> Andreas
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
_______________________________________________
Linux-usb-users@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-users
