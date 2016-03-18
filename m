From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/3] lpfc: fix misleading indentation
Date: Fri, 18 Mar 2016 15:22:31 -0400
Message-ID: <yq18u1fa8w8.fsf@sermon.lab.mkp.net>
References: <1457965789-3373916-1-git-send-email-arnd@arndb.de>
	<1457965789-3373916-3-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48650 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbcCRTWz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2016 15:22:55 -0400
In-Reply-To: <1457965789-3373916-3-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Mon, 14 Mar 2016 15:29:44 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Sebastian Herbszt <herbszt@gmx.de>

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> gcc-6 complains about the indentation of the
Arnd> lpfc_destroy_vport_work_array() call in lpfc_online(), which
Arnd> clearly doesn't look right:

Applied to 4.6/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
