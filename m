From: "Ben Sommer" <Ben.Sommer@berlin.de>
Subject: atp870u and acard scsi HELP
Date: Sun, 28 Dec 2003 08:31:53 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <KGELIIEMBLDPMKLCJKHKMEBJCGAA.Ben.Sommer@berlin.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:35535 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S264945AbTL1Hbz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Dec 2003 02:31:55 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have a SuSe 8.2 distribution and I like to test the new kernel 2.6 but
there is a little problem with my
scsi card. I have an Acard aes6712u/w and the driver is build into the
kernel with the version v2.6+ac but my bootdevice is on id8, it works fine
with my 2.4.x kernel but the new kernel 2.6 just scans the device up to 7
and my harddisk on ID8 is not recognised by the driver and my system is not
able to boot from device 823. Do u have a solution for this problem, I hope
you will have one :-)

Greetings from Berlin (germany)
Ben
