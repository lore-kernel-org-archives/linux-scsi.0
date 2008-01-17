From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc8-mm1 Build Failure on scsi driver
Date: Thu, 17 Jan 2008 21:45:39 +0530
Message-ID: <478F7F2B.9000801@linux.vnet.ibm.com>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:47867 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752028AbYAQQP4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 11:15:56 -0500
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fischer@norbit.de, Andy Whitcroft <apw@shadowen.org>, Balbir Singh <balbir@linux.vnet.ibm.com>

Hi Andrew,

The kernel build fails with following error

drivers/scsi/aha152x.o: In function `aha152x_host_reset_host':
/home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/aha152x.c:1324: multiple definition of `aha152x_host_reset_host'
drivers/scsi/pcmcia/built-in.o:/home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/aha152x.c:1324: first defined here
drivers/scsi/aha152x.o: In function `aha152x_release':
/home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/aha152x.c:908: multiple definition of `aha152x_release'
drivers/scsi/pcmcia/built-in.o:/home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/aha152x.c:908: first defined here
ld: Warning: size of symbol `aha152x_release' changed from 68 in drivers/scsi/pcmcia/built-in.o to 100 in drivers/scsi/aha152x.o
drivers/scsi/aha152x.o: In function `aha152x_probe_one':
/home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/aha152x.c:772: multiple definition of `aha152x_probe_one'
drivers/scsi/pcmcia/built-in.o:/home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/aha152x.c:772: first defined here
drivers/scsi/fdomain.o:(.data+0x0): multiple definition of `fdomain_driver_template'
drivers/scsi/pcmcia/built-in.o:(.data+0x5a0): first defined here
drivers/scsi/fdomain.o: In function `fdomain_16x0_bus_reset':
/home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/fdomain.c:1568: multiple definition of `fdomain_16x0_bus_reset'
drivers/scsi/pcmcia/built-in.o:/home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/fdomain.c:1568: first defined here
drivers/scsi/fdomain.o: In function `__fdomain_16x0_detect':
/home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/fdomain.c:894: multiple definition of `__fdomain_16x0_detect'
drivers/scsi/pcmcia/built-in.o:/home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/fdomain.c:894: first defined here
ld: Warning: size of symbol `__fdomain_16x0_detect' changed from 1206 in drivers/scsi/pcmcia/built-in.o to 1700 in drivers/scsi/fdomain.o
drivers/scsi/fdomain.o: In function `fdomain_setup':
/home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/fdomain.c:554: multiple definition of `fdomain_setup'
drivers/scsi/pcmcia/built-in.o:/home/kamalesh/scrap/linux-2.6.24-rc8/drivers/scsi/fdomain.c:554: first defined here
make[2]: *** [drivers/scsi/built-in.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
