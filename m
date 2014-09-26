From: Andras Kovacs <neoteny@freemail.hu>
Subject: blk-mq, scsi-mq, UFS
Date: Fri, 26 Sep 2014 22:14:06 +0000 (UTC)
Message-ID: <loom.20140927T001325-865@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37938 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574AbaIZWUH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2014 18:20:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1XXdrw-0005lw-8b
	for linux-scsi@vger.kernel.org; Sat, 27 Sep 2014 00:20:05 +0200
Received: from S0106602ad06f2965.gv.shawcable.net ([24.68.136.144])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 27 Sep 2014 00:20:04 +0200
Received: from neoteny by S0106602ad06f2965.gv.shawcable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sat, 27 Sep 2014 00:20:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

could someone explain to me:

- what is the difference between blk-mq and scsi-mq
- why don't I observe large speedups when running the same tiotests on Linux
v3.12 (which has no blk-mq) and Linux v3.14 (which does have blk-mq) on a
Xilinx Zynq development board (the two Linux versions are configured by
Xilinx Zynq and I know only how to add kernel command line parameters)?
- when Linux v3.17 becomes available (and Xilinx Zynq ports it for their
development board) will I see large speedups reading/writing to the target
SDD (which is driven through the UFS driver)?

Any and all info would be greatly appreciated.

