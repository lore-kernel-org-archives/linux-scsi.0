From: Michael Reed <mdr@sgi.com>
Subject: [REPOST][PATCH 0/6] mpt fusion - fibre channel updates / bug fixes
Date: Wed, 24 May 2006 15:06:38 -0500
Message-ID: <4474BCCE.8010009@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:14745 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1751275AbWEXUGq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 May 2006 16:06:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "Moore, Eric Dean" <Eric.Moore@lsil.com>

If possible, 2.6.17.  (Well, I can dream....)

Bugs fixed:

	* fibre channel target discovery prematurely terminates
	* fix infinite request/response loop during board reset
	* interrupting board reset with ctrl-c can leave board
	  unusable, requiring reboot to recover

Code reorg:

	* move fibre channel event and reset handling to mptfc
	  (better isolates future changes to this module)

Bug fix / feature: (depends upon point of view)

	* Set firmware target missing timers to one second so that
	  the transport's dev loss timer is more quickly started

