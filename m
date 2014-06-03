From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [SCSI] Fix T10-DIF-TYPE3 get_tag handler for multi-sector bios
Date: Tue, 03 Jun 2014 18:50:04 -0400
Message-ID: <yq1k38x38wz.fsf@sermon.lab.mkp.net>
References: <1401294293-18770-1-git-send-email-andreas.gruenbacher@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22427 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbaFCWuP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2014 18:50:15 -0400
In-Reply-To: <1401294293-18770-1-git-send-email-andreas.gruenbacher@gmail.com>
	(Andreas Gruenbacher's message of "Wed, 28 May 2014 18:24:53 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

>>>>> "Andreas" == Andreas Gruenbacher <andreas.gruenbacher@gmail.com> writes:

Andreas,

Andreas> The combined tag size in this case is 6 bytes; fix the loop.

I just posted a patch series that removes the tagging functions because
nobody was using them. Are you?

The patch looks good otherwise.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
