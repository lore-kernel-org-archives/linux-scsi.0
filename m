From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Disk spindown on rmmod sd_mod
Date: Tue, 2 Oct 2007 20:53:43 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710022050200.28124@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44833 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbXJBSxp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 14:53:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Hi,



I am using 2.6.23-rc9 with pata_sis. `modprobe -r sd_mod`, which I ran 
from initramfs, caused all my disks to spindown - sd even told me so.

I recall there has been talk a while back about whether to spin down 
disks on shutdown or not, but I do not think it touched the removal of 
sd_mod, did it? So either way, can someone fill me in why the spindown 
is done?
