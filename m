From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH][SCSI] mpt2sas: fix undefined reference to `__udivdi3' compilation errors
Date: Mon, 22 Sep 2014 09:42:49 -0400
Message-ID: <yq17g0vwz3a.fsf@sermon.lab.mkp.net>
References: <1411109247-18184-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411109247-18184-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	(Sreekanth Reddy's message of "Fri, 19 Sep 2014 12:17:27 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, fengguang.wu@intel.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> This patch will fix the below compilation errors on i386 ARCH
Sreekanth> drivers/built-in.o: In function `_scsih_qcmd':
Sreekanth> mpt2sas_scsih.c:(.text+0x1e7b56): undefined reference to
Sreekanth> `__udivdi3' mpt2sas_scsih.c:(.text+0x1e7b8a): undefined
Sreekanth> reference to `__umoddi3'

Sreekanth> Used sector_div() API to fix above compilation errors.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
