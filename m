From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/9] dm-mpath: don't call scsi_dh_attach when we want to retain the attached handler
Date: Fri, 01 May 2015 11:34:25 -0400
Message-ID: <yq1fv7guxa6.fsf@sermon.lab.mkp.net>
References: <1430415151-30948-1-git-send-email-hch@lst.de>
	<1430415151-30948-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21845 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbbEAPgj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2015 11:36:39 -0400
In-Reply-To: <1430415151-30948-4-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Thu, 30 Apr 2015 19:32:25 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

+	} else if (m->hw_handler_name) {
 		/*
 		 * Increments scsi_dh reference, even when using an
 		 * already-attached handler.

Shouldn't this comment be updated to reflect your previous patch?

-- 
Martin K. Petersen	Oracle Linux Engineering
