From: "Deas, Jim" <James.Deas@warnerbros.com>
Subject: RE: 3ware and scsi ids
Date: Tue, 3 Jun 2003 15:16:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <12C3C1794982613-01@MMS__ad.corp.aoltw.net_>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from h-64-236-243-31.twi.com ([64.236.243.31]:12849 "HELO
	atwburmw02.twi.com") by vger.kernel.org with SMTP id S261352AbTFCWGD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jun 2003 18:06:03 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org

I have never seen labels in the raidtab.
fstab yes. raidtab no. Is it possible?
Is this a better solution than LVM?
LVM seem to insert yet another layer.
I would like to avoid that if possible.

JD


-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk]
Sent: Tuesday, June 03, 2003 12:58 PM
To: Deas, Jim
Cc: linux-scsi@vger.kernel.org
Subject: Re: 3ware and scsi ids


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





