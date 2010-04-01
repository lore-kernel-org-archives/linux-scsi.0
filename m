From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/2] zfcp patches for 2.6.34-rc
Date: Thu, 01 Apr 2010 13:04:06 +0200
Message-ID: <20100401110406.973537000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:37023 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab0DALFv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2010 07:05:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com

James,

here are two zfcp patches for 2.6.34-rc. One updates the MAINTAINERS
entry for zfcp and the other one fixes a bug in the request tracing.
Both patches apply cleanly on top of the current scsi-rc-fixes git
tree.

--
Christof
