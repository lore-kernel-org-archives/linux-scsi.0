From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] scsi: Fix wrong additional sense length in descriptor format
Date: Mon, 13 Jul 2015 20:52:15 -0400
Message-ID: <yq1twt7tvb4.fsf@sermon.lab.mkp.net>
References: <1436697423-20611-1-git-send-email-sagig@mellanox.com>
	<1436697423-20611-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436697423-20611-2-git-send-email-sagig@mellanox.com> (Sagi
	Grimberg's message of "Sun, 12 Jul 2015 13:37:01 +0300")
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:

Sagi> The sense header additional sense length should be the accumulated
Sagi> size of all the descriptors. Information descriptor size is 12
Sagi> bytes.  When setting the additional sense length we should add 0xc
Sagi> instead of 0xa.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
