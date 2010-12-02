From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/7] zfcp updates for 2.6.38 merge window
Date: Thu, 02 Dec 2010 15:16:11 +0100
Message-ID: <20101202141611.976946976@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:46348 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793Ab0LBOTX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2010 09:19:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, maier@linux.vnet.ibm.com

James,

here is the series of zfcp updates for the 2.6.38 merge window. The
main change is the simplification of the internal debug traces. The
patches apply on top of the series of fixes sent here:

http://marc.info/?l=linux-scsi&m=129000042519762&w=2
http://marc.info/?l=linux-scsi&m=129000042119748&w=2
http://marc.info/?l=linux-scsi&m=129000042319755&w=2
http://marc.info/?l=linux-scsi&m=129000042819778&w=2
http://marc.info/?l=linux-scsi&m=129000042819775&w=2
http://marc.info/?l=linux-scsi&m=129008840529418&w=2

--
Christof
