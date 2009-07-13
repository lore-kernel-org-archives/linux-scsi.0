From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 00/13] zfcp fixes for 2.6.31-rc2
Date: Mon, 13 Jul 2009 15:06:01 +0200
Message-ID: <20090713130601.304914000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:49802 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbZGMNLT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2009 09:11:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com

James,

here is another series of zfcp fixes. About half of the fixes result
from a test case where zfcp has to detect and recover stalled
communication to the fcp channel, the other half are various fixes all
over.

The patches apply on top of the current git tree (2.6.31-rc2).

--
Christof
