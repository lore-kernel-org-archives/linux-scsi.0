From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] mpt3sas: Eliminate conditional locking in mpt3sas_scsih_issue_tm()
Date: Mon, 08 Aug 2016 21:12:11 -0400
Message-ID: <yq1eg5yvj84.fsf@sermon.lab.mkp.net>
References: <7afa9136f4edf40e29fddf4fcfbc9694724472f2.1469766027.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31572 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbcHIBMX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2016 21:12:23 -0400
In-Reply-To: <7afa9136f4edf40e29fddf4fcfbc9694724472f2.1469766027.git.calvinowens@fb.com>
	(Calvin Owens's message of "Thu, 28 Jul 2016 21:38:20 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

>>>>> "Calvin" == Calvin Owens <calvinowens@fb.com> writes:

Calvin> This flag that conditionally acquires the mutex is confusing and
Calvin> prone to bugginess: refactor it into two separate function
Calvin> calls, and make the unlocked one complain if it's called outside
Calvin> the mutex.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
