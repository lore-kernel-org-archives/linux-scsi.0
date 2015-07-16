From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 4/4] libiscsi: Use scsi helper to set information descriptor
Date: Wed, 15 Jul 2015 20:33:11 -0400
Message-ID: <yq1h9p5osag.fsf@sermon.lab.mkp.net>
References: <1436946939-19415-1-git-send-email-sagig@mellanox.com>
	<1436946939-19415-5-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436946939-19415-5-git-send-email-sagig@mellanox.com> (Sagi
	Grimberg's message of "Wed, 15 Jul 2015 10:55:39 +0300")
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:

Sagi> In case encountered a PI error, use scsi_set_sense_information
Sagi> instead of open coding information descriptor format.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
