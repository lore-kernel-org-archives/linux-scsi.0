From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 2/5] target: Split transport_send_check_condition_and_sense()
Date: Thu, 09 Jul 2015 12:15:18 -0400
Message-ID: <yq14mldtii1.fsf@sermon.lab.mkp.net>
References: <1436367534-15995-1-git-send-email-sagig@mellanox.com>
	<1436367534-15995-3-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436367534-15995-3-git-send-email-sagig@mellanox.com> (Sagi
	Grimberg's message of "Wed, 8 Jul 2015 17:58:51 +0300")
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:

Sagi> From: Bart Van Assche <bart.vanassche@sandisk.com> Move the code
Sagi> for translating a sense_reason_t code into a SCSI status ASC and
Sagi> ASCQ codes from transport_send_check_condition_and_sense() into
Sagi> the new function translate_sense_reason(). Convert the switch
Sagi> statement that performs the translation into table-driven code.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
