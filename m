From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fc: use get/put_unaligned64 for wwn access
Date: Fri, 18 Mar 2016 15:30:56 -0400
Message-ID: <yq1r3f78txr.fsf@sermon.lab.mkp.net>
References: <1458146385-278589-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17091 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbcCRTbR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2016 15:31:17 -0400
In-Reply-To: <1458146385-278589-1-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Wed, 16 Mar 2016 17:39:17 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <JBottomley@Odin.com>, Hannes Reinecke <hare@suse.de>, James Smart <james.smart@emulex.com>, "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> A bug in the gcc-6.0 prerelease version caused at least one driver
Arnd> (lpfc) to have excessive stack usage when dealing with wwn data,
Arnd> on the ARM architecture.

Applied to 4.6/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
