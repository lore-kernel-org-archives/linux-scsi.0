From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/3] scsi: Protect against buffer possible overflow in scsi_set_sense_information
Date: Mon, 13 Jul 2015 20:54:51 -0400
Message-ID: <yq1pp3vtv6s.fsf@sermon.lab.mkp.net>
References: <1436697423-20611-1-git-send-email-sagig@mellanox.com>
	<1436697423-20611-3-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436697423-20611-3-git-send-email-sagig@mellanox.com> (Sagi
	Grimberg's message of "Sun, 12 Jul 2015 13:37:02 +0300")
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:

Sagi> Make sure that the input sense buffer has sufficient length to fit
Sagi> the information descriptor (12 additional bytes).  Modify
Sagi> scsi_set_sense_information to receive the sense buffer length and
Sagi> adjust it's callers scsi target and libata.

Nitpicking: s/it's/its/

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
