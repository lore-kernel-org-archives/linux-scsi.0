From: Douglas Gilbert <dougg@torque.net>
Subject: sg3_utils-1.03 released
Date: Sun, 06 Apr 2003 10:27:18 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E8F7466.40406@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:19462 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262737AbTDFAOc (for <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Apr 2003 19:14:32 -0500
Received: from torque.net (d-241-81.stlucia.uq.net.au [203.101.241.81])
	by bunyip.cc.uq.edu.au (8.12.9/8.12.9) with ESMTP id h360PuGW000973
	for <linux-scsi@vger.kernel.org>; Sun, 6 Apr 2003 10:26:02 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Tarball and rpms found on http://www.torque.net/sg .
Summary of sg3_utils, sg_utils and other packages on
this page: http://www.torque.net/sg/u_index.html
A release announcement has been sent to freshmeat.net

Changelog for sg3_utils-1.03 [20030402]
   - sg_senddiag: added, allows self tests and listing of diag pages
   - sg_start: changed to use SG_IO so works on block devices
   - sg_err: print out some "sense key specific" data [Trent Piepho]
   - sg_modes: add "-6" switch for force 6 byte MODE SENSE [Trent Piepho]
   - sg_modes: more information on page codes and controls
   - sg_inq, sg_modes, sg_logs, sg_senddiag: add man pages
   - sg_dd: add "append=0|1" switch for glueing together large files
   - note in README about utilities offered by scsirastools package

Changelog for sg3_utils-1.02 [20030101]
   - sg_inq: check if cmddt or evpd bits ignored
   - sg_inq: warn -o=<n> not used for standard INQUIRY
   - sg_turs: add -t option to time Test Unit Ready commands
   - sg_errs: (used by most utilities) warn if sense buffer empty
   - sg_modes: make safe with block SG_IO (bypass SG_GET_SCSI_ID ioctl)
   - sg_logs: make safe with block SG_IO, self-test page work
   - sg_dd: add "blksg_io=" switch to experiment with block SG_IO
   - sg_read: now use SG_IO ioctl rather than sg write/read
   - sginfo: fix writing parameters, check for block devices that answer
     sg's ioctls, recognize "scd<n>" device names
   - sg_map: stop close error report on tape devices
   - sg_readcap: make safe with block SG_IO
   - sg_start: make safe with block SG_IO
   - sg_test_rwbuf: make safe with block SG_IO

A recent discovery was a utility called SeaTools from
Seagate ( http://www.seagate.com ). Although slanted
towards Seagate disks, it supports self tests, setting
performance critical mode page parameters, and formatting
(including to different block sizes). It seems to be
freely distributed in binary for Linux 2.4 series
(works fine with 2.5 as well).

Doug Gilbert

