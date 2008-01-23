From: Greg KH <greg@kroah.com>
Subject: Re: PATCH:
	usb-storage-set-last-sector-bug-flag.patch
Date: Wed, 23 Jan 2008 10:12:39 -0800
Message-ID: <20080123181239.GA21836@kroah.com>
References: <20080120205625.GB28842@kroah.com>
	<Pine.LNX.4.44L0.0801201642460.8504-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0801201642460.8504-100000@netrider.rowland.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, USB Storage list <usb-storage@lists.one-eyed-alien.net>, linux-usb@vger.kernel.org, David Brown <usb-storage2@davidb.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hans de Goede <j.w.r.degoede@hhs.nl>, Boaz Harrosh <bharrosh@panasas.com>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jan 20, 2008 at 04:45:36PM -0500, Alan Stern wrote:
> On Sun, 20 Jan 2008, Greg KH wrote:
> 
> > On Sun, Jan 20, 2008 at 11:27:29AM +0100, Hans de Goede wrote:
> > > Hi all,
> > >
> > > This patch sets the last_sector_bug flag to 1 for all USB disks. This is
> > > needed to makes the cardreader on various HP multifunction printers work.
> > >
> > > Since the performance impact is negible we set this flag for all USB disks 
> > > to avoid an unusual_devs.h nightmare.
> > 
> > Oh great, now my "working just fine" USB devices, which happen to have
> > data in the last sector, suddenly stop working.
> > 
> > That's not acceptable :(
> 
> These patches really should not impact existing devices.  If they do
> then something is definitely wrong.
> 
> Can you provide detailed logging information showing your problem?  For 
> example, a usbmon trace would be good.  Better yet, a usbmon trace 
> without the patches and a usbmon trace with the patches, for 
> comparison.

I don't have a device with such a problem, I just am worried that we are
now suddenly keeping access from the last sector for devices that
currently did work just fine.

If you all guarantee that this will not happen, hey, I'm happy, and I'll
gladly point all bug reports on to you all :)

thanks,

greg k-h

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
