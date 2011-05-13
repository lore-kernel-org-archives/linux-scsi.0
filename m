From: Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org>
Subject: aacraid adaptec 6805 support?
Date: Fri, 13 May 2011 16:12:42 +0200
Message-ID: <20110513141242.GA1048@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zenon.apartia.fr ([82.66.93.83]:32818 "EHLO zenon.apartia.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab1EMOMo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2011 10:12:44 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi,

I compiled the latest 2.6.38.x with aacraid support but my Adaptec RAID
6805 is not recognized:

http://www.adaptec.com/en-us/support/raid/sas_raid/sas-6805/

When I try building the driver source downloaded from adaptec I get a
compile error:

	CC      drivers/scsi/aacraid/commctrl.o
	drivers/scsi/aacraid/commctrl.c: In function 'open_getadapter_fib':
	drivers/scsi/aacraid/commctrl.c:449:3: error: implicit declaration of function 'init_MUTEX_LOCKED' [-Werror=implicit-function-declaration]
	cc1: some warnings being treated as errors

	make[3]: *** [drivers/scsi/aacraid/commctrl.o] Error 1
	make[2]: *** [drivers/scsi/aacraid] Error 2
	make[1]: *** [drivers/scsi] Error 2
	make: *** [drivers] Error 2

Any idea if that card is supported?

Thanks,
