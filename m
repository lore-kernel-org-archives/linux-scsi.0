From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] mpt3sas: Fix warnings exposed by W=1
Date: Mon, 08 Aug 2016 21:16:10 -0400
Message-ID: <yq160ravj1h.fsf@sermon.lab.mkp.net>
References: <7afa9136f4edf40e29fddf4fcfbc9694724472f2.1469766027.git.calvinowens@fb.com>
	<094fdbf57487af4f395238c0525b2a560c8f68f0.1469766027.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <094fdbf57487af4f395238c0525b2a560c8f68f0.1469766027.git.calvinowens@fb.com>
	(Calvin Owens's message of "Thu, 28 Jul 2016 21:38:22 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Calvin" == Calvin Owens <calvinowens@fb.com> writes:

Calvin> Trivial non-functional changes for a couple annoying things: 1)
Calvin> Functions local to files are not declared static, which is
Calvin> frustrating when reading the code because it's non-obvious at
Calvin> first glance what's actually called from other files.

Calvin>   2) Set-but-unused variables abound, presumably to mask
Calvin> -Wunused-result errors in the past. None of these are flagged
Calvin> today though (with one exception noted below), so remove them.

Calvin> Fixing (2) exposed the fact that we improperly ignore the return
Calvin> value of scsi_device_reprobe() in _scsih_reprobe_lun(). Fixing
Calvin> the calling code to deal with the potential error is
Calvin> non-trivial, so for now just WARN().

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
