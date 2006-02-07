From: Michael Morrison <mliam@adelphia.net>
Subject: scsi generic mem2disk patch for 2.6?
Date: Mon, 06 Feb 2006 23:14:40 -0800
Message-ID: <43E848E0.6010901@adelphia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta10.adelphia.net ([68.168.78.202]:4284 "EHLO
	mta10.adelphia.net") by vger.kernel.org with ESMTP id S964988AbWBGHSy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 02:18:54 -0500
Received: from [192.168.0.5] (really [70.34.61.98]) by mta10.adelphia.net
          (InterMail vM.6.01.05.02 201-2131-123-102-20050715) with ESMTP
          id <20060207071853.HHQR18877.mta10.adelphia.net@[192.168.0.5]>
          for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2006 02:18:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

Howdy,

There is a sg patch for 2.4 which allows a pci bus address, or rather a
virtual address, to be passed to the scsi generic driver in the
sg_io_hdr struct.   This patch works wonders for doing fast IO between
an HDTV capture card and a bunch of disks.

Is there such a beast for 2.6?   Does 2.6  already have this
functionality built in somehow?
If not, is there any reason why adding said functionality to the current
2.6.15 sg driver would not be doable?

 
see: http://sg.torque.net/sg/mem2disk.html

Thanks
