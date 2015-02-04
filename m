From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] mpt2sas: Remove usage of 'struct timeval'
Date: Wed, 04 Feb 2015 15:49:38 +0100
Message-ID: <4766539.lT9cszg5FO@wuerfel>
References: <20150204055835.GA4710@tinar>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:60478 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966308AbbBDOtn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Feb 2015 09:49:43 -0500
In-Reply-To: <20150204055835.GA4710@tinar>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>

On Wednesday 04 February 2015 11:28:35 Tina Ruchandani wrote:
> 'struct timeval' will have its tv_sec value overflow on 32-bit systems
> in year 2038 and beyond. This patch replaces the use of struct timeval
> for computing mpi_request.TimeStamp, and instead uses ktime_t which provides
> 64-bit seconds value. The timestamp computed remains unaffected (milliseconds
> since Unix epoch).
> 
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
> 

Looks good to me,

Acked-by: Arnd Bergmann <arnd@arndb.de>
