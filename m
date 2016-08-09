From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/3] mpt3sas: Eliminate dead sleep_flag code
Date: Mon, 08 Aug 2016 21:14:18 -0400
Message-ID: <yq1a8gmvj4l.fsf@sermon.lab.mkp.net>
References: <7afa9136f4edf40e29fddf4fcfbc9694724472f2.1469766027.git.calvinowens@fb.com>
	<88ad14a793c1703e6511a95e0b261b6f8bf25ef0.1469766027.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <88ad14a793c1703e6511a95e0b261b6f8bf25ef0.1469766027.git.calvinowens@fb.com>
	(Calvin Owens's message of "Thu, 28 Jul 2016 21:38:21 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Calvin" == Calvin Owens <calvinowens@fb.com> writes:

Calvin> With the exception of a single call to wait_for_doorbell_int(),
Calvin> all this conditional sleeping code is dead. So delete it.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
