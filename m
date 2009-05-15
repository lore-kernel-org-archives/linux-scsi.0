From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/9] zfcp updates for 2.6.31
Date: Fri, 15 May 2009 13:18:13 +0200
Message-ID: <20090515111813.314177000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:36363 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZEOLXU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2009 07:23:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com

James,

this is the series of zfcp patches for the 2.6.31 merge window. My
plan was to resubmit the zfcp FC pass-through patch to fix the small
issues found during review on linux-scsi. Now that the patch has
already been included in scsi-misc, i put the changes in a new patch.
I assume this is the simpler approach.

The patches apply on the current scsi-misc tree.

--
Christof Schmitt
