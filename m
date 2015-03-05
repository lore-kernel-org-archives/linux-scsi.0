From: Olaf Hering <olaf@aepfle.de>
Subject: use dedicated storage for scsi_debug LUNs
Date: Thu, 5 Mar 2015 16:33:39 +0100
Message-ID: <20150305153338.GA16293@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:38378 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822AbbCEPdm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2015 10:33:42 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

I'm using scsi_debug to implement and test tools for xen-scsiback. Today
I discovered that each LUN uses the very same storage, as described in
the docs. What would it take to optionally use dedicated storage for
each LUN?

This is how I load scsi_debug:
modprobe scsi_debug add_host=4 dev_size_mb=4 max_luns=4 num_parts=4 num_tgts=4 vpd_use_hostno=1

Olaf
