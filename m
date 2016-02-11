From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND] scsi: sim710: fix build warning
Date: Thu, 11 Feb 2016 09:36:21 -0500
Message-ID: <yq1r3gj5n6i.fsf@sermon.lab.mkp.net>
References: <1455166743-3572-1-git-send-email-sudipm.mukherjee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455166743-3572-1-git-send-email-sudipm.mukherjee@gmail.com>
	(Sudip Mukherjee's message of "Thu, 11 Feb 2016 10:29:03 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sudip" == Sudip Mukherjee <sudipm.mukherjee@gmail.com> writes:

Sudip> We are getting build warning about: "Section mismatch in
Sudip> reference from the variable sim710_eisa_driver to the function
Sudip> .init.text:sim710_eisa_probe() The variable sim710_eisa_driver
Sudip> references the function __init sim710_eisa_probe()"

Sudip> sim710_eisa_probe() was having __init but that was being
Sudip> referenced from sim710_eisa_driver.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
