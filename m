From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: PR API fixes for multipathing
Date: Fri, 15 Jul 2016 15:03:54 -0400
Message-ID: <yq1y452iuzp.fsf@sermon.lab.mkp.net>
References: <1467980631-18945-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36981 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbcGOTEJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2016 15:04:09 -0400
In-Reply-To: <1467980631-18945-1-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Fri, 8 Jul 2016 21:23:49 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> I was a bit overeager to thing ALL_TG_PT would solve all our
Christoph> multipathing woes in respect to persistent reservation.
Christoph> Turns out that there are lots of possible setups where it
Christoph> doesn't work, and we'll have to ask device mapper to register
Christoph> all underlying devices instead.

Should I queue the sd patch or let Mike take both through the DM tree?

-- 
Martin K. Petersen	Oracle Linux Engineering
