From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/9] dm-mpath, scsi_dh: request scsi_dh modules in scsi_dh, not dm-mpath
Date: Fri, 01 May 2015 11:35:39 -0400
Message-ID: <yq1bni4ux84.fsf@sermon.lab.mkp.net>
References: <1430415151-30948-1-git-send-email-hch@lst.de>
	<1430415151-30948-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28065 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbbEAPh4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2015 11:37:56 -0400
In-Reply-To: <1430415151-30948-5-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Thu, 30 Apr 2015 19:32:26 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> This way we can reused the same code any attachment method,
Christoph> not just those requested from dm-mpath.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
