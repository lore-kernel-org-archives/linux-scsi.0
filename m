From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/9] zfcp bug fixes for 2.6.35-rc4
Date: Thu, 08 Jul 2010 09:53:01 +0200
Message-ID: <20100708075301.347904000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.17.167]:32948 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab0GHIBM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 04:01:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com

James,

here is a series of zfcp bug fixes for the 2.6.35 cycle. I sent the
first three patches before. Since they have not been picked up
yet, i included them again:

http://marc.info/?l=linux-scsi&m=127710797409112&w=2
http://marc.info/?l=linux-scsi&m=127710797409115&w=2
http://marc.info/?l=linux-scsi&m=127710797609129&w=2

The other patches address problems with recovering remote port
problems.

The patch series applies cleanly on top of the current linux-2.6 git
tree (2.6.35-rc4).

--
Christof
