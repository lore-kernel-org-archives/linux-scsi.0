From: christophe varoqui <christophe.varoqui@free.fr>
Subject: [ANNOUNCE] multipath-tools-0.1.6
Date: Sun, 25 Apr 2004 23:54:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082930099.3158.13.camel@zezette>
Reply-To: christophe.varoqui@free.fr
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp10.wanadoo.fr ([193.252.22.21]:8345 "EHLO
	mwinf1002.wanadoo.fr") by vger.kernel.org with ESMTP
	id S263620AbUDYVzC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Apr 2004 17:55:02 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org

Hello,

here goes multipath-tools-0.1.6

Changelog for this release :

* add the dmadm WIP tool (read MD superblocks and create
  corresponding devmaps when possible)
* plug fd leak in TUR path checker (multipathd)

Please note dmadm should not be run anywhere near a production machine with useful data on MD raids.
That said comments and contributions are welcome.

Downloads and docs at http://christophe.varoqui.free.fr

regards,
cvaroqui

