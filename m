From: Andrew Morton <akpm@osdl.org>
Subject: Fw: advansys.c problems in 2.6.0-test2
Date: Sat, 2 Aug 2003 13:05:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030802130522.0b517fa9.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:29634 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S270256AbTHBUET (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Aug 2003 16:04:19 -0400
List-Id: linux-scsi@vger.kernel.org
To: Gene Heskett <gene.heskett@verizon.net>
Cc: linux-scsi@vger.kernel.org


You'll need to Cc: the linux-scsi folks for the advansys problem.

Do any of the SCSI maintaniers actually have Advansys hardware?

Is the vendor actively maintaining the driver?  It seems not.



Begin forwarded message:

Date: Sat, 2 Aug 2003 09:46:30 -0400
From: Gene Heskett <gene.heskett@verizon.net>
To: linux-kernel@vger.kernel.org
Subject: advansys.c problems in 2.6.0-test2


Greetings;

As suggested earlier, I've made the scsi support a module so
that the rest of the system can boot, and the errant scsi 
driver then modprobed in.

During the compile, these warnings are issued:
--
  CC [M]  drivers/i2c/i2c-sensor.o
drivers/i2c/i2c-sensor.c: In function `i2c_detect':
drivers/i2c/i2c-sensor.c:54: warning: `check_region' is deprecated (declared at include/linux/ioport.h:117)
--
  CC [M]  drivers/scsi/advansys.o
drivers/scsi/advansys.c: In function `advansys_detect':
drivers/scsi/advansys.c:4622: warning: `check_region' is deprecated (declared at include/linux/ioport.h:117)
drivers/scsi/advansys.c: In function `AscSearchIOPortAddr11':
drivers/scsi/advansys.c:10004: warning: `check_region' is deprecated (declared at include/linux/ioport.h:117)
--
sensors doesn't work but I can live with that for a bit.
This mobo has never run at less than 168F on the cpu,
and I have thermaltake's best on it.  The cpu runs 100%
doing setiathome full time.

However, after the bootup, an attempt to 'modprobe advansys'
will first do a bus reset, then find the tape drive as usual,
and then hang the process while attempting another bus reset.
Occasionally, not everytime, it will output a message about
a bad pointer.

And the scsi stuff I can't do without.  I have sent a msg
to what used to be advansys, but have not rx'd a reply as
its the weekend for 9-5 types.

This driver has been best described as bulletproof up till
now.

How should I proceed?

-- 
Cheers, Gene
AMD K6-III@500mhz 320M
Athlon1600XP@1400mhz  512M
99.27% setiathome rank, not too shabby for a WV hillbilly
Yahoo.com attornies please note, additions to this message
by Gene Heskett are:
Copyright 2003 by Maurice Eugene Heskett, all rights reserved.

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

