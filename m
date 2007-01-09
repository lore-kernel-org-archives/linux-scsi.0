From: Dmitriy Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/5] fixing errors handling during pci_driver resume stage
Date: Tue, 09 Jan 2007 12:00:49 +0300
Message-ID: <87wt3wmv5q.fsf@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:9259 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbXAIJAq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Jan 2007 04:00:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, devel@openvz.org, linux-pci@atrey.karlin.mff.cuni.cz, netdev@vger.kernel.org, linux-scsi@vger.kernel.org

Where are several places where errors ignored during pci_driver resume stage.
In most most cases return value of 'pci_enable_device()' was ignored.
drivers from such subsystems affected:
 - ata
 - fusion
 - ide
 - mmc
 - net
 - parisc
 - parport
 - pci
 - serial

