From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/6] sd: fix up ->compat_ioctl
Date: Wed, 05 Nov 2014 09:29:51 -0500
Message-ID: <yq17fz9en4w.fsf@sermon.lab.mkp.net>
References: <1414661229-15199-1-git-send-email-hch@lst.de>
	<1414661229-15199-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29020 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbaKEO36 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2014 09:29:58 -0500
In-Reply-To: <1414661229-15199-4-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Thu, 30 Oct 2014 10:27:06 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> No need to verify the passthrough ioctls, the real handler
Christoph> will take care of that.  Also make sure not to block for
Christoph> resets on O_NONBLOCK fds.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
