From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] hpsa: Fix type ZBC conditional checks
Date: Tue, 10 May 2016 21:59:39 -0400
Message-ID: <yq1y47hnylw.fsf@sermon.lab.mkp.net>
References: <1462819450.16056.2.camel@petroskoutoupis.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50916 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbcEKB7v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2016 21:59:51 -0400
In-Reply-To: <1462819450.16056.2.camel@petroskoutoupis.com> (Petros
	Koutoupis's message of "Mon, 09 May 2016 13:44:10 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Petros Koutoupis <petros@petroskoutoupis.com>
Cc: don.brace@microsemi.com, linux-scsi@vger.kernel.org, iss_storagedev@hp.com, esc.storagedev@microsemi.com

>>>>> "Petros" == Petros Koutoupis <petros@petroskoutoupis.com> writes:

Petros> The device ID obtained from the inquiry can only be of a single
Petros> type.  The original code places a check for TYPE_ZBC right after
Petros> the check for TYPE_DISK. Logically, if the first if statement
Petros> sees a device of a TYPE_DISK and moves on to the second
Petros> statement checking if not TYPE_ZBC, it will always hit the
Petros> continue.

Did not apply to 4.7/scsi-queue. I merged it by hand.

-- 
Martin K. Petersen	Oracle Linux Engineering
