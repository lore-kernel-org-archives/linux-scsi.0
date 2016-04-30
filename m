From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5] qla1280: Don't allocate 512kb of host tags
Date: Fri, 29 Apr 2016 20:28:31 -0400
Message-ID: <yq1a8kc6its.fsf@sermon.lab.mkp.net>
References: <1461746932-123934-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35933 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbcD3A2s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Apr 2016 20:28:48 -0400
In-Reply-To: <1461746932-123934-1-git-send-email-jthumshirn@suse.de> (Johannes
	Thumshirn's message of "Wed, 27 Apr 2016 10:48:52 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Michael Reed <mdr@sgi.com>, Laura Abbott <labbott@redhat.com>, Laurence Oberman <loberman@redhat.com>, Lee Duncan <lduncan@suse.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, stable@vger.kernel.org, #@suse.de, v4.4@suse.de

>>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:

Johannes> The qla1280 driver sets the scsi_host_template's can_queue
Johannes> field to 0xfffff which results in an allocation failure when
Johannes> allocating the block layer tags for the driver's queues. This
Johannes> was introduced with the change for host wide tags in commit
Johannes> 64d513ac31b - "scsi: use host wide tags by default".

Johannes> Reduce can_queue to MAX_OUTSTANDING_COMMANDS (512) to solve
Johannes> the allocation error.

Applied to 4.6/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
