From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND PATCH] mpt2sas: Remove usage of 'struct timeval'
Date: Wed, 11 Nov 2015 20:42:44 -0500
Message-ID: <yq1vb98t2ln.fsf@sermon.lab.mkp.net>
References: <20151030090515.GA3542@tina-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41287 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbbKLBnA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2015 20:43:00 -0500
In-Reply-To: <20151030090515.GA3542@tina-laptop> (Tina Ruchandani's message of
	"Fri, 30 Oct 2015 02:05:15 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, y2038@lists.linaro.org

>>>>> "Tina" == Tina Ruchandani <ruchandani.tina@gmail.com> writes:

Tina,

Tina> 'struct timeval' will have its tv_sec value overflow on 32-bit
Tina> systems in year 2038 and beyond. This patch replaces the use of
Tina> struct timeval for computing mpi_request.TimeStamp, and instead
Tina> uses ktime_t which provides 64-bit seconds value. The timestamp
Tina> computed remains unaffected (milliseconds since Unix epoch).

We just consolidated the mpt2sas and mpt3sas drivers into one so I'm
afraid your time tweaks will have to be rebased. I encourage you repost
in a couple of weeks after the merge window dust settles.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
