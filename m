From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [usb-storage] Malfunctioning USB stick
Date: Thu, 13 May 2004 22:16:15 +0200
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <200405132216.15436.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0405131408110.651-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0405131408110.651-100000@ida.rowland.org>
Content-Disposition: inline
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, usb-storage@lists.one-eyed-alien.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Am Donnerstag, 13. Mai 2004 20:09 schrieb Alan Stern:
> On Thu, 13 May 2004, Oliver Neukum wrote:
> 
> > Hi,
> > 
> > this stick is acting up.
> > I just mounted it and got (no disconnection physically):
> 
> It looks like some sort of I/O problem reading the partition table.  What 
> do you get with verbose usb-storage debugging enabled?

It turns out that the stick is defect. I've tested it on three computers
and two operating systems. In fact during tests it got alarmingly hot.
I think, there's little sense in further testing. It already turned up
one little issue in the scsi code and I am impressed at the quality
of our error handling :-)
Now I'll have the pleasure the return it to the shop on a friday :-(

	Regards
		Oliver


-------------------------------------------------------
This SF.Net email is sponsored by: SourceForge.net Broadband
Sign-up now for SourceForge Broadband and get the fastest
6.0/768 connection for only $19.95/mo for the first 3 months!
http://ads.osdn.com/?ad_id=2562&alloc_id=6184&op=click
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
