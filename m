From: Phillip Jackson <pjackson@chesapeakeimaging.net>
Subject: RAID drivers for PERC 3/DCL
Date: Tue, 21 Mar 2006 10:06:14 -0500
Message-ID: <20060321100614.94b64rxf7gf4k84c@webmail.chesapeakeimaging.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacksongrp.com ([72.3.133.45]:52668 "EHLO
	burrito.jacksongrp.com") by vger.kernel.org with ESMTP
	id S1030419AbWCUPGG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Mar 2006 10:06:06 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am seeking some help with a situation I'm confronting.  I have two Dell
Poweredge 1550's with PERC 3/DCL RAID.  I am attemtping to install Fedora Core
4 on these servers and after installation, the computer operates for only a few
moments, but when I start writing data to the disk (downloading packages/etc)
the computer locks up and does not respond to user input.  This also happened
when installing Ubuntu 5.04 and 5.10.  It seems the megaraid driver, which is
included with the Fedora Core 4 installer, should support this firmware.

Any thoughts?

--
Phillip Jackson
Chief Technology Officer
Chesapeake Medical Imaging

Tel. 443/716-0410
Mbl. 202/841-0090

