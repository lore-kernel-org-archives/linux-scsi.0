From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 00/11] Updated zfcp patches for 2.6.27
Date: Wed, 02 Jul 2008 10:56:30 +0200
Message-ID: <20080702085630.473635000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:6135 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbYGBJAj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jul 2008 05:00:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

James,

this replaces the patch series sent on June 30th. The only changes are
the string handling while parsing the kernel parameter for the initial
device and one fix in the erp patch. Patches apply to current
scsi-misc.

Christof
