From: Douglas Gilbert <dougg@torque.net>
Subject: sg3_utils-1.05 released
Date: Thu, 13 Nov 2003 22:21:09 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FB37735.7070204@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:24331 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264145AbTKMMVc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 07:21:32 -0500
Received: from torque.net (d-240-159.stlucia.uq.net.au [203.101.240.159])
	by bunyip.cc.uq.edu.au (8.12.10/8.12.10) with ESMTP id hADCLNb6023284
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2003 22:21:25 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Tarball and rpms can be found on http://www.torque.net/sg .
Summary of sg3_utils, sg_utils and other packages are on
this page: http://www.torque.net/sg/u_index.html
A release announcement will be sent to freshmeat.net
shortly.

Changelog for sg3_utils-1.05 [20031112]
   - sginfo: major rework; add IE page, clean up control, cache +
         disconnect pages (as per SPC-3 and SBC-2).
       - when storing, update saved page (change from previous
         version)
       - use 10 byte mode sense and select by default (override
         with '-6')
       - mode subpage support
   - sg_dd, sgm_dd + sgp_dd:
       - 64 bit capable (read capacity; count, skip and seek
         values).
       - numerical arguments accept hex (prefixed by '0x' or '0X')
       - require bpt > 0
       - fix problem when reading /dev/null
   - sg_dd: Treat SIGUSR1 properly: print stats and continue;
   - sgp_dd: reduce READ CAPACITY response size to 8 bytes
   - sg_read: require bpt > 0
   - sg_test_rwbuf: switch from sg_header to sg_io_hdr interface
     N.B. After these changes no sg3_utils utilities (in the
     main directory) use the sg_header interface
   - sg_scan: switch from sg_header to sg_io_hdr interface
   - sg_senddiag: increase extended foreground timeout to 60
     minutes
   - sg_inq: add names of peripheral device types
   - sg_readcap: show total size in bytes, MB, GB
   - sg_logs: read log pages twice (first time to get response
     length), for fragile HBAs; decode Seagate 0x37 + 0x3e
     pages; display pcbs
   - sg_modes: fix core dump when corrupted response, don't
     print extra pages
   - sg_map: increase sg device scanning from 128 to 256
   - change man page references from lk 2.5 to lk 2.6
   - examples/sg_iovec_tst: added testing sg_iovec (sg_io_hdr
     iovec's)
   - utils/hxascdmp: add utility for displaying ASCII hex

Doug Gilbert

