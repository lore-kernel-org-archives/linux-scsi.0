From: Tino Keitel <tino.keitel+firewire@tikei.de>
Subject: Re: Spin down disk at suspend/shotdown
Date: Thu, 3 Apr 2008 17:20:17 +0200
Message-ID: <20080403152017.GA32750@dose.home.local>
References: <20080403064910.GB7716@dose.home.local>
	<47F4F35E.50309@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-user-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <47F4F35E.50309@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-user>
List-Post: <mailto:linux1394-user@lists.sourceforge.net>
List-Help: <mailto:linux1394-user-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-user-bounces@lists.sourceforge.net
Errors-To: linux1394-user-bounces@lists.sourceforge.net
To: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 03, 2008 at 17:10:22 +0200, Stefan Richter wrote:
> (Added Cc: LSML)
> 
> Tino Keitel wrote at linux1394-user:
> > with my SATA and USB drives, I used to use the manage_start_stop setting
> > to make the disks spin down at suspend and shutdown. Here is an example
> > for my USB disk:
> > 
> > $ echo 1 > /sys/class/scsi_disk/4\:0\:0\:0/manage_start_stop
> > 
> > This doesn't work with my firewire drive. The disk doesn't spin down.
> > Of cause, I use the correct entry in /sys/class/scsi_disk/.
> 
> Which kernel?

I tested at least 2.6.24 and 2.6.25-rc.

> Which disk?

This is an ICY Box case with USB and Firewire interfaces. The hard disk
is a Western Digital WD 3200 3,5" IDE disk.

> Are there messages in dmesg which relate to this?

Yes. At suspend:

2008-04-03_06:09:39.14083 kern.notice: sd 6:0:0:0: [sdg] Synchronizing SCSI cache
2008-04-03_06:09:39.14088 kern.notice: sd 6:0:0:0: [sdg] Stopping disk

And at resume:

2008-04-03_06:09:39.17189 kern.debug: sd 6:0:0:0: resuming
2008-04-03_06:09:39.17190 kern.notice: sd 6:0:0:0: [sdg] Starting disk

Regards,
Tino

-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
