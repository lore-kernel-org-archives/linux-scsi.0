From: Tom Rini <trini@ti.com>
Subject: Commit a692b0e broke my mvsas card
Date: Mon, 16 Apr 2012 15:42:50 -0700
Message-ID: <20120416224250.GA1983@bill-the-cat>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61031 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab2DPWm4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Apr 2012 18:42:56 -0400
Received: by obbta14 with SMTP id ta14so4239637obb.19
        for <linux-scsi@vger.kernel.org>; Mon, 16 Apr 2012 15:42:55 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, James Bottomley <JBottomley@Parallels.com>, Xiangliang Yu <yuxiangl@marvell.com>

Hey all,

I have an OCZ RevoDrive3 X2 (which the mvsas driver works for).  I've
been running mainline since support for my card was added and I just
went to test 3.3-rc4.  Unpatched I get some sort of recursive fault that
locks up the system.  When I revert a692b0e (which I found with a git
bisect) things are working as expected again.  What info do you need
from me to work out the right solution here?  Thanks!

-- 
Tom
