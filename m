From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] esas2r: Fix array overrun
Date: Wed, 17 Feb 2016 19:16:45 -0500
Message-ID: <yq1si0qswia.fsf@sermon.lab.mkp.net>
References: <20160215190123.11294.22634.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49065 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965331AbcBRARD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2016 19:17:03 -0500
In-Reply-To: <20160215190123.11294.22634.stgit@localhost.localdomain> (Alan's
	message of "Mon, 15 Feb 2016 19:01:29 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan <gnomes@lxorguk.ukuu.org.uk>
Cc: thenzl@redhat.com, linux-scsi@vger.kernel.org

>>>>> "Alan" == Alan  <gnomes@lxorguk.ukuu.org.uk> writes:

Alan> Check the array size *before* dereferencing it with a user
Alan> provided offset

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
