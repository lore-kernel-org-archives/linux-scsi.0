From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/2] zfcp: Fabric and channel latencies from FCP adapter
Date: Tue, 06 May 2008 11:00:04 +0200
Message-ID: <20080506090004.922666000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:20899 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764734AbYEFJFv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 May 2008 05:05:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

These patches let zfcp track the fabric and channel latencies provided
by the FCP adapter. The first patch adds the infrastructure to
retrieve the data from each completed request and the second patch
adds the sysfs attributes to read the data from userspace.

The patches apply to scsi-misc.

Christof
