From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] imm: check parport_claim
Date: Thu, 25 Feb 2016 21:11:18 -0500
Message-ID: <yq1oab4gr09.fsf@sermon.lab.mkp.net>
References: <1456311431-18521-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456311431-18521-1-git-send-email-sudipm.mukherjee@gmail.com>
	(Sudip Mukherjee's message of "Wed, 24 Feb 2016 16:27:11 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sudip" == Sudip Mukherjee <sudipm.mukherjee@gmail.com> writes:

Sudip> parport_claim() can fail and we should be checking if we were
Sudip> able to claim the port.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
