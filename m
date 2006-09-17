From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_debug version 1.80 against 2.6.18-rc7
Date: Sat, 16 Sep 2006 20:30:47 -0400
Message-ID: <450C9737.2090206@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060806090705090207060207"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:2182 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964884AbWIQAaw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Sep 2006 20:30:52 -0400
Received: from ip-163.60.99.216.dsl-cust.ca.inter.net ([216.99.60.163] helo=[192.168.48.80])
	by pentafluge.infradead.org with esmtpsa (Exim 4.62 #1 (Red Hat Linux))
	id 1GOkYc-0007FJ-F9
	for linux-scsi@vger.kernel.org; Sun, 17 Sep 2006 01:30:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------060806090705090207060207
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The scsi_debug patch referred to in this post:
http://marc.theaimsgroup.com/?l=linux-scsi&m=114956710925458&w=2
plus this patch from Randy Dunlap:
http://marc.theaimsgroup.com/?l=linux-scsi&m=115267662413264&w=2
have appeared in the lk 2.6.18-rc series and should be in
the lk 2.6.18 release. Several folks have sent patches
which are in the attachment. The patch is gzipped and is
against lk 2.6.18-rc7 for consideration in lk 2.6.19 .

See http://www.torque.net/sg/sdebug26.html for more
information on the scsi_debug driver.

ChangeLog:
  - add 'vpd_use_hostno' parameter to allow simulated hosts
    to see the same set of targets (and luns). For testing
    multipath software.
  - add 'fake_rw' parameter to ignore the data in READ and
    WRITE commands
  - add support for log subpages (new in SPC-4)
  - yield appropriate block descriptor for MODE SENSE
    commands (only for pdt=0 (i.e. disks))
  - REQUEST SENSE response no longer shows the stopped
    power condition (SAT changed to agree with SPC-3)

Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert

--------------060806090705090207060207
Content-Type: application/x-gzip;
 name="sdebug2618rc7c.diff.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="sdebug2618rc7c.diff.gz"

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
--------------060806090705090207060207--
