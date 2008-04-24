From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/3] zfcp: Add sysfs attributes for polling adapter data
Date: Thu, 24 Apr 2008 19:35:51 +0200
Message-ID: <20080424173551.821393000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:56882 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYDXRk4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 13:40:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

The FCP adapter on the System z platform provides some additional data
that can be polled from device drivers. The first two patches in this
series prepare the FSF command layer in zfcp for polling the
additional data. The third patch implements the sysfs attributes that
can be read to get the data.

The patch series is a part of the previously send zfcp adapter
statistics. We split old patch to make the change more transparent for
reviewing.

The patch series applies to current scsi-misc.

Christof
