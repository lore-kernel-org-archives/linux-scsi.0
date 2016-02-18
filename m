From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] aic7xxx: Fix queue depth handling
Date: Wed, 17 Feb 2016 19:16:09 -0500
Message-ID: <yq1wpq2swja.fsf@sermon.lab.mkp.net>
References: <20160215185301.27731.20754.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46755 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965331AbcBRARg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2016 19:17:36 -0500
In-Reply-To: <20160215185301.27731.20754.stgit@localhost.localdomain> (Alan's
	message of "Mon, 15 Feb 2016 18:53:15 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan <gnomes@lxorguk.ukuu.org.uk>
Cc: hare@suse.com, linux-scsi@vger.kernel.org

>>>>> "Alan" == Alan  <gnomes@lxorguk.ukuu.org.uk> writes:

Alan> We were setting the queue depth correctly, then setting it back to
Alan> two. If you hit this as a bisection point then please send me an
Alan> email as it would imply we've been hiding other bugs with this
Alan> one.

Applied to 4.6/scsi-queue, CC:stable@.

-- 
Martin K. Petersen	Oracle Linux Engineering
