From: "Deas, Jim" <James.Deas@warnerbros.com>
Subject: 3ware and scsi ids
Date: Tue, 3 Jun 2003 11:05:21 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <12C23B584849261-01@MMS__ad.corp.aoltw.net_>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from h-64-236-243-31.twi.com ([64.236.243.31]:36511 "HELO
	atwburmw02.twi.com") by vger.kernel.org with SMTP id S261548AbTFCR6M convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jun 2003 13:58:12 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am currently using 3wares products to create 2T raids.
To increase performance on my NAS type boxes I am
using software raids.
 My problem relates to a falure of a IDE drive.
Once a drive fails the next boot of the machine remaps all scsi ids.
so /dev/sda-adi becomes /dev/sda-sdh.
In short, if /dev/sdb dies, all raids become bad as all scsi ids
shift down making my raidtab file now point at the wrong drives.
(I assume this will also be a possible problem when I use
my USB dongle to update software.)

 Is there a way to hard assign logical /dev/sd(x) in the driver
so they will always map the same ide port on the 3ware controllers?
3ware is no help on this. They say it is the bios/system and they
have no control over this.

Thanks
J. Deas


