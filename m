From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] target: Return descriptor format sense data
Date: Mon, 13 Jul 2015 20:57:10 -0400
Message-ID: <yq1lhejtv2x.fsf@sermon.lab.mkp.net>
References: <1436697423-20611-1-git-send-email-sagig@mellanox.com>
	<1436697423-20611-4-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436697423-20611-4-git-send-email-sagig@mellanox.com> (Sagi
	Grimberg's message of "Sun, 12 Jul 2015 13:37:03 +0300")
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:

Sagi> Fixed size sense data information field is only 32 bits which
Sagi> means the sector (64 bits) information will be truncated.

Sagi> Move to descriptor format sense data to correctly report full
Sagi> sector information.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
