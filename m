From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/1] One more zfcp fix for 2.6.33-rc
Date: Tue, 26 Jan 2010 17:49:18 +0100
Message-ID: <20100126164918.824991000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:44449 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab0AZQwr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2010 11:52:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com

James,

here is one more fix for zfcp in the current 2.6.33-rc cycle. The
patch applies to the current scsi-rc-fixes tree.

We missed that problem in the last round of bsg fixes in zfcp, i hope
this is the last one.
--
Christof Schmitt
