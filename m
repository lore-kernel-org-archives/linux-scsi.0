From: Douglas Gilbert <dougg@torque.net>
Subject: scsi changes to lk 2.4.21
Date: Thu, 26 Jun 2003 11:22:03 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EFA4ABB.7040407@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:33029 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S265285AbTFZBHy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2003 21:07:54 -0400
Received: from torque.net (d-242-15.stlucia.uq.net.au [203.101.242.15])
	by bunyip.cc.uq.edu.au (8.12.9/8.12.9) with ESMTP id h5Q1M1hp013423
	for <linux-scsi@vger.kernel.org>; Thu, 26 Jun 2003 11:22:02 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here is a list of scsi subsystem changes from lk 2.4.16
through to lk 2.4.21 . A more comprehensive list can be
found in
   http://www.torque.net/scsi/SCSI-2.4-HOWTO/apbs06.html


  * [2.4.17]     add     generic_unplug_device()    call    to
    scsi_wait_req().     This     stops    long    waits    in
    SCSI_IOCTL_SEND_COMMAND.
  * [2.4.17] fix device scanning bug where, in some cases, the
    scsi_level (i.e. SCSI standard adherence) was misplaced.
  * [2.4.17] major sg driver update, add mmap()-ed IO
  * [2.4.18]  permit  upper  level  driver  "init()" functions
    (e.g.    sd_init()    )    to    fail   gracefully.   [Add
    Scsi_Device::detected and scsi_unregister_module() .]
  * [2.4.18] Fix for clustering (SCSI commands) on MO devices.
  * [2.4.18] st driver update (compression algorithms).
  * [2.4.18]       update      Documentation/scsi.txt      and
    scsi-generic.txt .
  * [2.4.18] Revamp scsi_debug driver .
  * [2.4.19]  Scsi  reservation  and  reset  capability added.
    Reservations  allow  multiple  machines  to share the same
    device  (via a reserve/release mechanism). Scsi reset (via
    sg)   is  needed  to  "break"  a  reservation  held  by  a
    non-responding machine.
  * [2.4.19]  Introduce  BLIST_LARGELUN  to handle LUNs larger
    than 7 despite reporting SCSI 2.
  * [2.4.19]  Change  sd  and  sr  so  RECOVERED_ERROR  is not
    treated as a hard error. Send warning to log/console.
  * [2.4.19]  Zero  out  sg's  buffers before use. [Sg version
    upgraded  from  3.1.22 to 3.1.24 but this is not reflected
    in sg.h (supeficial).]
  * [2.4.20]  Support  for highmem I/O added. Used by aic7xxx,
    3w-xxxx, esp, megaraid, qlogicfc and sym53c8xx_2 LLDs.
  * [2.4.20]  "blocking_open"  boot  time,  module  load  time
    parameter added to st.
  * [2.4.21]  Give new HBAs a new host number (higher than any
    previously used) unless there is a "scsihosts" match. Host
    numbering  sequence "holes" are only re-used if there is a
    "scsihosts" match.
  * [2.4.21]  stop  the  SCSI  status  RECOVERED  ERROR  being
    treated as an error by the mid level (complements a change
    in 2.4.19).
  * [2.4.21]  use  the  TEST_UNIT_READY  command  (rather than
    START_STOP)  to  determine  if removable media has changed
    (in sd driver).
  * [2.4.21] major work on ide-scsi driver.
  * [2.4.21]   add   aic79xx  driver  for  Adaptec  Ultra  320
    controllers.


Doug Gilbert

