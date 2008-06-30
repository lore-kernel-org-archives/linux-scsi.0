From: christof.schmitt@de.ibm.com
Subject: [patch 00/11] zfcp updates for 2.6.27
Date: Mon, 30 Jun 2008 12:52:36 +0200
Message-ID: <20080630105236.960064000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:48270 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851AbYF3LCP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2008 07:02:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

James,

here are the final large zfcp updates for 2.6.27.

The first patches are small fixes for problems that were found with
the last updates. One patch moves the helper functions for the
scsi_cmnd status to the common scsi include file. The last patches are
the large code cleanups.

The patches apply to current scsi-misc.

Christof
