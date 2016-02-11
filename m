From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/7] SCSI bug fixes for 4.6
Date: Wed, 10 Feb 2016 20:24:21 -0500
Message-ID: <yq1si1082ey.fsf@sermon.lab.mkp.net>
References: <1453910247-3447628-1-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21244 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbcBKBYy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2016 20:24:54 -0500
In-Reply-To: <1453910247-3447628-1-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Wed, 27 Jan 2016 16:57:16 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James.Bottomley@HansenPartnership.com, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> Here are a bunch of fixes for harmless bugs I found during ARM
Arnd> randconfig testing. It would be nice to get them mered in 4.6, but
Arnd> there is no need to have them in 4.5 as no incorrect behavior
Arnd> results from the current code, and the warnings are all hard to
Arnd> trigger.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
