From: Stephen Atkins <satkins@skircr.com>
Subject: Serial ATA (sii3512a) support
Date: Sat, 23 Sep 2006 10:35:22 -0600
Message-ID: <4515624A.4090100@skircr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751280AbWIWQh2@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello everyone.  I'm just wondering what the status is for the Silicon
Image 3512a serial ata support is.

I was using gentoo-sources 2.6.12 my Seagate drives worked fine.  I'm
now running a gentoo-sources 2.6.15-r1 and support has broken.  The same
thing with gentoo-sources 2.6.17-r8.  I've added my drives to the
sata_sil.c black list (one of them was missing) but I still get
"Abnormal status 0x58 on port ..." errors.  Which essentially crashes my
machine.

Unfortunately I don't have the 2.6.12 kernel from Gentoo any more as I
did a emerge --sync and it got rid of it.  Also some of the other
drivers I'm using need more recent kernel versions.

Just some notes on my MB/chipsets.  I've got a Gigabyte GA-7N400Pro2
with an nForce2 chipset.  It has a on board SATA which the manual says
is a Sil3112 but the bios reports it as a Sil3512a.  I've got a single 6
gig IDE as my boot device and root dir.  There are also two SATA drives
both are Seagates.  One is a ST3250823AS (250 gigs) and a ST3120026AS
(120 gigs).  I know the Seagate drives have some issues and hence the
black list.

Just wondering if there is anything I can do to make these things work
in some of the latest kernels.  Thanks for you help.

-- 

Stephen Atkins
