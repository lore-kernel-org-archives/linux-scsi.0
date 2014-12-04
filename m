From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 09/22] [SCSI] mpt2sas, mpt3sas: Added a support to set cpu affinity for each MSIX vector enabled by the HBA
Date: Wed, 03 Dec 2014 22:16:12 -0500
Message-ID: <yq11toghzpf.fsf@sermon.lab.mkp.net>
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1416467155-16869-10-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416467155-16869-10-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Thu, 20 Nov 2014 12:35:42 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> Added a support to set cpu affinity mask for each MSIX vector
Sreekanth> enabled by the HBA, So that by runnig the irqbalancer,
Sreekanth> interrupts can be balanced among the cpus.

Wouldn't it be better to do this in _base_assign_reply_queues since
we're already iterating there?

-- 
Martin K. Petersen	Oracle Linux Engineering
