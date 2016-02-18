From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] lpfc: fix missing zero termination in debugfs
Date: Wed, 17 Feb 2016 19:17:01 -0500
Message-ID: <yq1oabeswhu.fsf@sermon.lab.mkp.net>
References: <20160215191142.19028.9220.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49106 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965331AbcBRARO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2016 19:17:14 -0500
In-Reply-To: <20160215191142.19028.9220.stgit@localhost.localdomain> (Alan's
	message of "Mon, 15 Feb 2016 19:11:56 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org, jthumshirn@suse.de

>>>>> "Alan" == Alan  <gnomes@lxorguk.ukuu.org.uk> writes:

Alan> If you feed 32 bytes in then the kstrtoull() doesn't receive a
Alan> terminated string so will run off the end.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
