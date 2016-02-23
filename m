From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND] dpt_i2o: fix build warning
Date: Tue, 23 Feb 2016 17:44:58 -0500
Message-ID: <yq1r3g3jbbp.fsf@sermon.lab.mkp.net>
References: <1455784153-9615-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455784153-9615-1-git-send-email-sudipm.mukherjee@gmail.com>
	(Sudip Mukherjee's message of "Thu, 18 Feb 2016 13:59:13 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sudip" == Sudip Mukherjee <sudipm.mukherjee@gmail.com> writes:

Sudip> We were getting build warning about:
Sudip> drivers/scsi/dpt_i2o.c:183:29: warning: 'dptids' defined but not
Sudip> used

Sudip> dptids[] is only used in the MODULE_DEVICE_TABLE so when MODULE
Sudip> is not defined then dptids[] becomes unused.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
