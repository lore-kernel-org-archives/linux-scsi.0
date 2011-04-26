From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Subject: bfa (2.1.2.1) on 2.6.32.29-0.3-xen reports "Unknown" port_type
Date: Tue, 26 Apr 2011 14:56:00 +0200
Message-ID: <4DB6DD00020000A100005B96@gwsmtp1.uni-regensburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rrzmta4.uni-regensburg.de ([194.94.155.55]:43874 "EHLO
	rrzmta4.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab1DZNF6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2011 09:05:58 -0400
Received: from rrzmta4.uni-regensburg.de (localhost [127.0.0.1])
	by localhost (Postfix) with SMTP id 8597124EA
	for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2011 14:56:06 +0200 (CEST)
Received: from gwsmtp1.uni-regensburg.de (gwsmtp1.uni-regensburg.de [132.199.5.51])
	by rrzmta4.uni-regensburg.de (Postfix) with ESMTP id 6E18923B9
	for <linux-scsi@vger.kernel.org>; Tue, 26 Apr 2011 14:56:06 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi!

This is for SLES11 SP1 with a Brocade-815 and bfa 2.1.2.1. The 8Gb HBA is attached to a 4Gb FC-Switch. The HBA is logged in to the fabric and SAN disks can be accessed just fine.
Unfortunately the port_type reports "Unknown" instead of "NPort" (or similar). I don't know why.

# for f in /sys/class/scsi_host/host3/device/fc_host/host3/*; do [ -f $f ] && echo "$f: $(<$f)"; done
/sys/class/scsi_host/host3/device/fc_host/host3/active_fc4s: 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x01 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
/sys/class/scsi_host/host3/device/fc_host/host3/fabric_name: 0x1000080088e35fbd
/sys/class/scsi_host/host3/device/fc_host/host3/maxframe_size: 2112 bytes
/sys/class/scsi_host/host3/device/fc_host/host3/node_name: 0x200000051efb3dc8
/sys/class/scsi_host/host3/device/fc_host/host3/port_id: 0x661b13
/sys/class/scsi_host/host3/device/fc_host/host3/port_name: 0x100000051efb3dc8
/sys/class/scsi_host/host3/device/fc_host/host3/port_state: Online
/sys/class/scsi_host/host3/device/fc_host/host3/port_type: Unknown
/sys/class/scsi_host/host3/device/fc_host/host3/speed: 4 Gbit
/sys/class/scsi_host/host3/device/fc_host/host3/supported_classes: Class 3
/sys/class/scsi_host/host3/device/fc_host/host3/supported_fc4s: 0x00 0x00 0x01 0x00 0x00 0x00 0x00 0x01 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
/sys/class/scsi_host/host3/device/fc_host/host3/supported_speeds: 1 Gbit, 2 Gbit, 4 Gbit, 8 Gbit
/sys/class/scsi_host/host3/device/fc_host/host3/symbolic_name: Brocade Brocade-815 FV2.1.2.1   DV2.1.2.1
/sys/class/scsi_host/host3/device/fc_host/host3/tgtid_bind_type: wwpn (World Wide Port Name)
/sys/class/scsi_host/host3/device/fc_host/host3/uevent:


Regards,
Ulrich
P.S. Please CC any replies to me as I'm not subscribed to the list

