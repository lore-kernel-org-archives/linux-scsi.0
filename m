From: "Smart, James" <James.Smart@Emulex.com>
Subject: Transport affected timeouts...
Date: Fri, 16 Apr 2004 11:40:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF2802C0169E@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:10688 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S263304AbUDPPkz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Apr 2004 11:40:55 -0400
Received: from xbl.ad.emulex.com (xbl.ma.emulex.com [138.239.73.11])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id i3GFercj018949
	for <linux-scsi@vger.kernel.org>; Fri, 16 Apr 2004 08:40:54 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

All,

One issue that we're wrestling with in our driver is timeout values. In the
past, we've encountered large configurations where the timeouts from the
midlayer are insufficient. In general - we'd like the scsi host to be able
to add a transport/topology increment time to the base timeout values.  The
methodology would have to be dynamic as it may change as link connectivity
changes.

Obviously, an hba driver mucking with the timeout values handed to it is
frowned upon. Is there a recommendation on how we should handle this ?

-- james s
