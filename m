From: Adrian Bunk <bunk@fs.tum.de>
Subject: Binary-only firmware covered by the GPL?
Date: Thu, 25 Mar 2004 23:08:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040325220803.GZ16746@fs.tum.de>
References: <E1B6Izr-0002Ai-00@r063144.stusta.swh.mhn.de> <20040325082949.GA3376@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:3057 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S263634AbUCYWIN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Mar 2004 17:08:13 -0500
Content-Disposition: inline
In-Reply-To: <20040325082949.GA3376@gondor.apana.org.au>
List-Id: linux-scsi@vger.kernel.org
To: 239952@bugs.debian.org, debian-devel@lists.debian.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

There's another issue with these files:

>From drivers/scsi/qla2xxx/ql2100_fw.c in kernel 2.6:

<--  snip  -->

/******************************************************************************
 *                  QLOGIC LINUX SOFTWARE
 *
 * QLogic ISP2x00 device driver for Linux 2.6.x
 * Copyright (C) 2003-2004 QLogic Corporation
 * (www.qlogic.com)
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2, or (at your option) any
 * later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 
*************************************************************************/

/*
 *      Firmware Version 1.19.24 (14:02 Jul 16, 2002)
 */

...

#ifdef UNIQUE_FW_NAME
unsigned short fw2100tp_code01[] = { 
#else
unsigned short risc_code01[] = { 
#endif
        0x0078, 0x102d, 0x0000, 0x95f1, 0x0000, 0x0001, 0x0013, 0x0018,
        0x0017, 0x2043, 0x4f50, 0x5952, 0x4947, 0x4854, 0x2032, 0x3030,
        0x3120, 0x514c, 0x4f47, 0x4943, 0x2043, 0x4f52, 0x504f, 0x5241,
        0x5449, 0x4f4e, 0x2049, 0x5350, 0x3231, 0x3030, 0x2046, 0x6972,
...

<--  snip  -->


The GPL says that you must give someone receiving a binary the source 
code, and it says:
  The source code for a work means the preferred form of the work for
  making modifications to it.


This is perhaps a bit besides the main firmware discussion and IANAL, 
but is this file really covered by the GPL?


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


