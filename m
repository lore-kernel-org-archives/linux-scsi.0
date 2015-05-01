From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/9] dm-mpath, scsi_dh: don't let dm detach device handlers
Date: Fri, 01 May 2015 11:30:59 -0400
Message-ID: <yq1k2wsuxfw.fsf@sermon.lab.mkp.net>
References: <1430415151-30948-1-git-send-email-hch@lst.de>
	<1430415151-30948-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19827 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbbEAPdP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2015 11:33:15 -0400
In-Reply-To: <1430415151-30948-3-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Thu, 30 Apr 2015 19:32:24 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> While allowing dm-mpath to attach device handlers is a
Christoph> functionality we need for backwards compatibility reason
Christoph> there is no reason to reference count them and detach them if
Christoph> dm-mpath stops using the device for some reason.

Christoph> If the device handler works for the given device it can just
Christoph> stay attached.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
