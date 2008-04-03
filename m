From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Spin down disk at suspend/shotdown
Date: Thu, 03 Apr 2008 17:53:59 +0200
Message-ID: <47F4FD97.5060103@s5r6.in-berlin.de>
References: <20080403064910.GB7716@dose.home.local>	<47F4F35E.50309@s5r6.in-berlin.de>
	<20080403152017.GA32750@dose.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-user-bounces@lists.sourceforge.net>
In-Reply-To: <20080403152017.GA32750@dose.home.local>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-user>
List-Post: <mailto:linux1394-user@lists.sourceforge.net>
List-Help: <mailto:linux1394-user-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-user-bounces@lists.sourceforge.net
Errors-To: linux1394-user-bounces@lists.sourceforge.net
To: Tino Keitel <tino.keitel+firewire@tikei.de>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Tino Keitel wrote:
> This is an ICY Box case with USB and Firewire interfaces.

Most or all oft the ICY Box combo interface HDD enclosures are based on
the PL3507 bridge chip.  One thing you could try is to update its
firmware.  The firmware uploader requires Windows and USB.
http://www.raidsonic.de/de/pages/service/driver.php
http://www.prolific.com.tw/eng/downloads.asp?ID=44  (apparently has a
newer firmware than raidsonic)

>> > Are there messages in dmesg which relate to this?
> 
> Yes. At suspend:
> 
> 2008-04-03_06:09:39.14083 kern.notice: sd 6:0:0:0: [sdg] Synchronizing SCSI cache
> 2008-04-03_06:09:39.14088 kern.notice: sd 6:0:0:0: [sdg] Stopping disk
> 
> And at resume:
> 
> 2008-04-03_06:09:39.17189 kern.debug: sd 6:0:0:0: resuming
> 2008-04-03_06:09:39.17190 kern.notice: sd 6:0:0:0: [sdg] Starting disk

So there are at least no discernible errors...
-- 
Stefan Richter
-=====-==--- -=-- ---==
http://arcgraph.de/sr/

-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
