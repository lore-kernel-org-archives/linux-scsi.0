From: Tejun Heo <htejun@gmail.com>
Subject: Question about scsi_device_online() usage in mptscsih
Date: Sat, 2 Apr 2005 14:35:57 +0900
Message-ID: <20050402053557.GA22422@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.201]:61380 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261713AbVDBFgB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Apr 2005 00:36:01 -0500
Received: by rproxy.gmail.com with SMTP id j1so811918rnf
        for <linux-scsi@vger.kernel.org>; Fri, 01 Apr 2005 21:36:01 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsil.com, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

 Hello, Eric.
 Hello, James.

 I've been working on new SCSI state model and was checking on
scsi_device_online() users.  As the state model is going to change, I
need to audit device state usages in lldd's and I'm having difficult
time understanding why scsi_device_online() is used in mptscsih.

 In mptscsih.c, mptscsih_flush_running_cmds() uses
scsi_device_online() to determine whether or not dma-unmap data area
of active commands.  This was added in the changeset 1.1371.776.1 by
Eric Moore with the comment "MPT Fusion add back FC909 support".  Can
you please explain me why and how scsi_device_online() condition is
used here?

 Thanks a lot. :-)

-- 
tejun

