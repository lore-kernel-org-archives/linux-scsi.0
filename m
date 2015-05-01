From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 6/9] scsi_dh: move device matching to the core code
Date: Fri, 01 May 2015 11:39:19 -0400
Message-ID: <yq1383gux20.fsf@sermon.lab.mkp.net>
References: <1430415151-30948-1-git-send-email-hch@lst.de>
	<1430415151-30948-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24256 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbbEAPle (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2015 11:41:34 -0400
In-Reply-To: <1430415151-30948-7-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Thu, 30 Apr 2015 19:32:28 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Add a single list of devices that need non-ALUA device
Christoph> handlers to the core scsi_dh code so that we can autoload the
Christoph> modules for them at probe time.

Christoph> While this is a little ugly in terms of architecture

I think that approach is perfectly fine.

Christoph> it actually significantly simplifies the code in addition to
Christoph> the new autoloading functionality.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
