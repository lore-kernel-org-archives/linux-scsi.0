From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 3ware and scsi ids
Date: 03 Jun 2003 20:57:49 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1054670267.9234.59.camel@dhcp22.swansea.linux.org.uk>
References: <12C23B584849261-01@MMS__ad.corp.aoltw.net_>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc2-cwma1-4-cust86.swan.cable.ntl.com ([213.105.254.86]:12417
	"EHLO lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S261151AbTFCUmF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jun 2003 16:42:05 -0400
In-Reply-To: <12C23B584849261-01@MMS__ad.corp.aoltw.net_>
List-Id: linux-scsi@vger.kernel.org
To: "Deas, Jim" <James.Deas@warnerbros.com>
Cc: linux-scsi@vger.kernel.org

On Maw, 2003-06-03 at 19:05, Deas, Jim wrote:
> In short, if /dev/sdb dies, all raids become bad as all scsi ids
> shift down making my raidtab file now point at the wrong drives.
> (I assume this will also be a possible problem when I use
> my USB dongle to update software.)

Yes that sometimes comes up, along with a wonderful variant where 
USB cameras beat the PCI sound card to being first sound device
> 
>  Is there a way to hard assign logical /dev/sd(x) in the driver
> so they will always map the same ide port on the 3ware controllers?
> 3ware is no help on this. They say it is the bios/system and they
> have no control over this.

Correct.

The vendor Linux systems mostly support mount by label so you can
avoid using anything but the file system label to find a disk if
something vanishes.

So you'll see lines like this in /etc/fstab

LABEL=/boot             /boot                   ext3    defaults       1
2



