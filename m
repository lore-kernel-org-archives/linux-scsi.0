From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/8] zfcp update
Date: Tue, 10 Jun 2008 18:20:53 +0200
Message-ID: <20080610162053.144590000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:51762 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbYFJQZ7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2008 12:25:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

James,

here is a large update for zfcp. The patch series cleans up parts of
the code in the driver, removes the driver specific message macros and
removes unnecessary debug messages. FC ports are now automatically
attached and the port_state attribute is added in the FC host sysfs.

The patches apply to current scsi-misc.

Christof
