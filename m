From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] SCSI: sd: fix null dereference
Date: Sat, 07 Mar 2015 08:46:16 -0500
Message-ID: <yq1pp8kc447.fsf@sermon.lab.mkp.net>
References: <1425707254-10877-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425707254-10877-1-git-send-email-sudipm.mukherjee@gmail.com>
	(Sudip Mukherjee's message of "Sat, 7 Mar 2015 11:17:34 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sudip" == Sudip Mukherjee <sudipm.mukherjee@gmail.com> writes:

Sudip> we were dereferencing sdkp first and then we were checking for it
Sudip> being NULL.

http://marc.info/?l=linux-kernel&m=142564395705827&w=2

-- 
Martin K. Petersen	Oracle Linux Engineering
