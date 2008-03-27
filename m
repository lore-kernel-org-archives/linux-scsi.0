From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 00/11] zfcp debug trace update
Date: Thu, 27 Mar 2008 14:21:54 +0100
Message-ID: <20080327132154.826339000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:30844 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759172AbYC0NaZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2008 09:30:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

James,

this patch series updates the debug trace in zfcp that we use on s390.
The first five patches move some hex dump trace data from printks to
the traces, the later ones update the erp trace to a better format
that contains more useful trace information than the old 16 byte
dumps.

The patches apply to current scsi-misc.

Christof
