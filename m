From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [SCSI] mpt2sas T10 DIF fixes
Date: Fri, 17 Aug 2012 12:00:55 -0400
Message-ID: <yq1lihdh5jc.fsf@sermon.lab.mkp.net>
References: <1329788184-6477-1-git-send-email-martin.petersen@oracle.com>
	<50237151.9000801@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:24491 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab2HQQBM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Aug 2012 12:01:12 -0400
In-Reply-To: <50237151.9000801@suse.com> (Ankit Jain's message of "Thu, 09 Aug
	2012 13:44:09 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ankit Jain <jankit@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Eric.Moore@lsi.com

>>>>> "Ankit" == Ankit Jain <jankit@suse.com> writes:

Ankit> Will these patches be merged? Or have they been superseded by
Ankit> some other patchset?

Sorry, I've been out on vacation.

2 of the patches are absolutely trivial and should just be applied.
However, LSI objects to patch #3 which tweaks an incorrect NVDATA flag
from within the driver.

Instead LSI has promised to revert to the original behavior in their
firmware/NVDATA updates. Eric, can you give us an update? There was
another bug report on linux-scsi just a couple of weeks ago.

-- 
Martin K. Petersen	Oracle Linux Engineering
