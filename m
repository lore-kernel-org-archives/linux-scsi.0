From: Douglas Gilbert <dougg@torque.net>
Subject: sg3_utils-1.07 released
Date: Thu, 08 Jul 2004 10:12:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40ED5647.7060707@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomts36.bellnexxia.net ([209.226.175.93]:36828 "EHLO
	tomts36-srv.bellnexxia.net") by vger.kernel.org with ESMTP
	id S261378AbUGHOMT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jul 2004 10:12:19 -0400
Received: from torque.net ([67.68.52.9]) by tomts36-srv.bellnexxia.net
          (InterMail vM.5.01.06.10 201-253-122-130-110-20040306) with ESMTP
          id <20040708141218.FRCD13900.tomts36-srv.bellnexxia.net@torque.net>
          for <linux-scsi@vger.kernel.org>; Thu, 8 Jul 2004 10:12:18 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Tarball and rpms can be found on http://www.torque.net/sg .
Summary of sg3_utils, sg_utils and other packages are on
this page: http://www.torque.net/sg/u_index.html
A release announcement will be sent to freshmeat.net
shortly.

Changelog for sg3_utils-1.07 [20040708]
   - sginfo: clean up inquiry vendor,product,revision strings
       - '-Fhead': sort defect list by head
	Tom Steudten <steudten at mx dot ch>
   - rework sg_err for better command name coverage: service actions,
     variable length and peripheral device type
       - update asc,ascq codes to SPC-3 revision 19
   - move scsi_devfs_scan to archive directory
   - add sg_opcodes utility to list supported operation codes
   - add sg_persist utility to support persistent reservations
   - add '-i' option to sg_inq to decode device identification VPD
     page (0x83)
   - sg_inq tries an ATA IDENTITY if SCSI INQUIRY fails
   - sg_dd, sgm_dd and sgp_dd calculate block device sizes (if count
     not given)
   - drop SG_GET_VERSION_NUM ioctl guard in most utilities


Doug Gilbert
