From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 1/5] target: Inline transport_get_sense_codes()
Date: Thu, 09 Jul 2015 12:13:58 -0400
Message-ID: <yq18uaptik9.fsf@sermon.lab.mkp.net>
References: <1436367534-15995-1-git-send-email-sagig@mellanox.com>
	<1436367534-15995-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18322 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbbGIQOk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2015 12:14:40 -0400
In-Reply-To: <1436367534-15995-2-git-send-email-sagig@mellanox.com> (Sagi
	Grimberg's message of "Wed, 8 Jul 2015 17:58:50 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:

Sagi> From: Bart Van Assche <bart.vanassche@sandisk.com> Inline this
Sagi> function in its call site since it performs a trivial task and
Sagi> since it is only called once.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
