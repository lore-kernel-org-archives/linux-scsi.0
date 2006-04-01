From: Doug Maxey <dwm@maxeymade.com>
Subject: [CMT 00/16] qla4xxx: driver review
Date: Fri, 31 Mar 2006 22:18:52 -0600
Message-ID: <200604010418.k314Iqam008288@falcon30.maxeymade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:51074 "EHLO
	falcon30.maxeymade.com") by vger.kernel.org with ESMTP
	id S1750868AbWDAETG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Mar 2006 23:19:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Howdy!

I know the driver works very well for this stage of maturity.  It survived
96+ hours of I/O stress test on a power5 system, driving 2 targets
through 2 402x cards.

Now lets make the code look as good as it works. :->

Here is my review of the qla4xxx driver as patched up through the
0011-Updated-scsi-Kconfig-to-include-qla4xxx-Kconfig-path.txt.

The breakdown is by alphabetical filenames from a diff of all the
files with the latest patches.

Followups in this series:
[CMT 01/16] qla4xxx: driver review ql4_attr.c
[CMT 02/16] qla4xxx: driver review ql4_dbg.c
[CMT 03/16] qla4xxx: driver review ql4_dbg.h
[CMT 04/16] qla4xxx: driver review ql4_def.h
[CMT 05/16] qla4xxx: driver review ql4_fw.h
[CMT 06/16] qla4xxx: driver review ql4_glbl.h
[CMT 07/16] qla4xxx: driver review ql4_init.c
[CMT 08/16] qla4xxx: driver review ql4_inline.h
[CMT 09/16] qla4xxx: driver review ql4_iocb.c
[CMT 10/16] qla4xxx: driver review ql4_isr.c
[CMT 11/16] qla4xxx: driver review ql4_mbx.c
[CMT 12/16] qla4xxx: driver review ql4_nvram.c
[CMT 13/16] qla4xxx: driver review ql4_nvram.h
[CMT 14/16] qla4xxx: driver review ql4_os.c
[CMT 15/16] qla4xxx: driver review ql4_setting.h
[CMT 16/16] qla4xxx: driver review ql4_version.h

++doug

