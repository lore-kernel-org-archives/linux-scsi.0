From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 4/5] target: Use scsi helpers to build the sense data correctly
Date: Thu, 09 Jul 2015 12:17:18 -0400
Message-ID: <yq1vbdts3u9.fsf@sermon.lab.mkp.net>
References: <1436367534-15995-1-git-send-email-sagig@mellanox.com>
	<1436367534-15995-5-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436367534-15995-5-git-send-email-sagig@mellanox.com> (Sagi
	Grimberg's message of "Wed, 8 Jul 2015 17:58:53 +0300")
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:

Sagi> Instead of open coding the sense buffer construction, use scsi
Sagi> scsi_build_sense_buffer() and scsi_set_sense_information() helpers
Sagi> which moved to scsi_common.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
