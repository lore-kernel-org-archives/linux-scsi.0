From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 1/2] scsi: fix race between simultaneous decrements of ->host_failed
Date: Wed, 08 Jun 2016 23:11:25 -0400
Message-ID: <yq1k2hzjbtu.fsf@sermon.lab.mkp.net>
References: <1465282437-10653-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1465282437-10653-1-git-send-email-fangwei1@huawei.com> (Wei
	Fang's message of "Tue, 7 Jun 2016 14:53:56 +0800")
Sender: linux-doc-owner@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>
Cc: tj@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, corbet@lwn.net, hch@infradead.org, dan.j.williams@intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Wei" == Wei Fang <fangwei1@huawei.com> writes:

Wei> sas_ata_strategy_handler() adds the works of the ata error handler
Wei> to system_unbound_wq. This workqueue asynchronously runs work
Wei> items, so the ata error handler will be performed concurrently on
Wei> different CPUs. In this case, ->host_failed will be decreased
Wei> simultaneously in scsi_eh_finish_cmd() on different CPUs, and
Wei> become abnormal.

Applied to 4.7/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
