From: christophe.varoqui@free.fr
Subject: [ANNOUNCE] multipath-tools-0.1.8
Date: Fri, 14 May 2004 09:29:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1084519750.40a47546dd0e6@imp1-q.free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix4-1.free.fr ([213.228.0.62]:6320 "EHLO
	postfix4-1.free.fr") by vger.kernel.org with ESMTP id S264057AbUENH3L
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 May 2004 03:29:11 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org

Hello,

here goes multipath-tools-0.1.8

Changelog for this release :

        * Makefiles cleanup and factorisation
        * Compilation fixes for non-ix86 archs, tested on x86_64
        * strip execs harder for a 10% size reduction
        * blacklist /dev/fd* and /dev/loop*
        * dmadm works with sysfs nodes with '!' (cciss for ex)

Downloads and docs at http://christophe.varoqui.free.fr

regards,
cvaroqui

-- 
