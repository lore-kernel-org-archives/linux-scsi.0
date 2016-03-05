From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 08/14] scsi: mvumi: use __maybe_unused to hide pm functions
Date: Sat, 05 Mar 2016 17:08:49 -0500
Message-ID: <yq17fhg4lxq.fsf@sermon.lab.mkp.net>
References: <1456934350-1389172-1-git-send-email-arnd@arndb.de>
	<1456934350-1389172-9-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50867 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbcCEWJX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Mar 2016 17:09:23 -0500
In-Reply-To: <1456934350-1389172-9-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Wed, 2 Mar 2016 16:59:00 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> The mvumi scsi hides the references to its suspend/resume
Arnd> functions in an #ifdef but does not hide the implementation the
Arnd> same way:

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
