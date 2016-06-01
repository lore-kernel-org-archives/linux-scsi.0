From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] [SCSI] aacraid: use kmemdup
Date: Tue, 31 May 2016 22:24:41 -0400
Message-ID: <yq1shwxwsra.fsf@sermon.lab.mkp.net>
References: <1463666915-16906-1-git-send-email-falakreyaz@gmail.com>
	<1463666915-16906-3-git-send-email-falakreyaz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1463666915-16906-3-git-send-email-falakreyaz@gmail.com>
	(Muhammad Falak R. Wani's message of "Thu, 19 May 2016 19:38:33
	+0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Muhammad Falak R Wani <falakreyaz@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Muhammad" == Muhammad Falak R Wani <falakreyaz@gmail.com> writes:

Muhammad> Use kmemdup when some other buffer is immediately copied into
Muhammad> allocated region. It replaces call to allocation followed by
Muhammad> memcpy, by a single call to kmemdup.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
