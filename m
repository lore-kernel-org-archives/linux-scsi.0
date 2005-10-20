From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Recover SCSI disks
Date: Thu, 20 Oct 2005 15:40:31 +0100
Message-ID: <dj8a8v$ta0$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:9374 "EHLO ciao.gmane.org")
	by vger.kernel.org with ESMTP id S1751124AbVJTO5g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 10:57:36 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1ESblI-0006Da-6O
	for linux-scsi@vger.kernel.org; Thu, 20 Oct 2005 16:51:20 +0200
Received: from 83-216-145-213.pambow882.adsl.metronet.co.uk ([83.216.145.213])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2005 16:51:20 +0200
Received: from robin-lists by 83-216-145-213.pambow882.adsl.metronet.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2005 16:51:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I've got a Compaq U2 storage array connected to a Compaw Smart 2/p
controller with an assortment of 4.3GB and 9.1GB disks that I use for
testing purposes.

Some of the drives have "died" on me, i.e. I get yellow lights when they
are plugged into the arrays.

Is it possible to do anything low-level to ressurect these drives? e.g.
take them out of their caddies, connected them directly to a SCSI
controller and low-level format them or something?

(There's no data on them - I just want them to work again!)

Any suggestions appreciated.

R.
-- 
http://robinbowes.com

If a man speaks in a forest,
and his wife's not there,
is he still wrong?

