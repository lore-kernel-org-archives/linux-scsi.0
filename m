From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Tue, 10 Jun 2008 21:38:09 +0200
Message-ID: <484ED821.8020904@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0806091040440.2943-100000@iolanthe.rowland.org>
	<484D8019.3090900@s5r6.in-berlin.de>
	<200806101900.43572.chris2553@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <200806101900.43572.chris2553@googlemail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: chris2553@googlemail.com
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

Chris Clayton wrote:
> I only 
> use firewire on the rare occasion that I want to grab some video from my camera 
> and I use the parallel port even less frequently. So one of the last things 
> that happens in my rc.local init script is that I unload the related drivers.

On an unrelated note:  If the driver was automatically loaded in a 
hotplug-like fashion (based on PCI IDs and module aliases), you could 
prevent it with "blacklist ohci1394" in one of the modprobe 
configuration files.
-- 
Stefan Richter
-=====-==--- -==- -=-=-
http://arcgraph.de/sr/

-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://sourceforge.net/services/buy/index.php
