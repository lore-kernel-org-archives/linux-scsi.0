From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 09/22] [SCSI] mpt2sas, mpt3sas: Added a support to set cpu affinity for each MSIX vector enabled by the HBA
Date: Fri, 09 Jan 2015 15:58:16 -0500
Message-ID: <yq1twzzzn6f.fsf@sermon.lab.mkp.net>
References: <1420635329-2268-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1420635329-2268-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Wed, 7 Jan 2015 18:25:29 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: martin.petersen@oracle.com, jejb@kernel.org, hch@infradead.org, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Elliott@hp.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> Change_set: 1. Added affinity_hint varable of type
Sreekanth> cpumask_var_t in adapter_reply_queue structure. And allocated
Sreekanth> a memory for this varable by calling alloc_cpumask_var.
Sreekanth> 2. Call the API irq_set_affinity_hint for each MSIx vector to
Sreekanth> affiniate it with calculated cpus at driver inilization time.
Sreekanth> 3. While freeing the MSIX vector, call this same API to
Sreekanth> release the cpu affinity mask for each MSIx vector by
Sreekanth> providing the NULL value in cpumask argument.  4. then call
Sreekanth> the free_cpumask_var API to free the memory allocated in step
Sreekanth> 2.

(Still dreaming of a combined mpt2sas and mpt3sas so I wouldn't have to
review everything twice).

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
