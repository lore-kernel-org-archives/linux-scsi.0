From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 00/22] zfcp patches for 2.6.33 merge window
Date: Tue, 24 Nov 2009 16:53:56 +0100
Message-ID: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:44300 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758084AbZKXQBb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:01:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com

Here is the series of zfcp patches for the 2.6.33 merge window.

The first patch adds the target reset flag to the fc_fcp.h header file
to replace the private zfcp definition of this flag. The other zfcp
patches include:
 - rework locking and reference counting for zfcp structs
 - module unloading
 - use common code FC protocol definitions instead of private ones
 - minor updates and cleanup

--
Christof Schmitt
