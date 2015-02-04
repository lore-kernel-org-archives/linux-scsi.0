From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] mpt3sas: Remove usage of 'struct timeval'
Date: Wed, 04 Feb 2015 15:50:13 +0100
Message-ID: <2366319.ligdMUJdIB@wuerfel>
References: <20150204044512.GA4432@tinar>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:56747 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965223AbbBDOuT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Feb 2015 09:50:19 -0500
In-Reply-To: <20150204044512.GA4432@tinar>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>

On Wednesday 04 February 2015 10:15:12 Tina Ruchandani wrote:
> 'struct timeval' will have its tv_sec value overflow on 32-bit systems
> in year 2038 and beyond. This patch replaces the use of struct timeval
> for computing mpi_request.TimeStamp, and instead uses ktime_t which provides
> 64-bit seconds value. The timestamp computed remains unaffected (milliseconds
> since Unix epoch).
> 
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
> 

Same change as for mpt2sas, so

Acked-by: Arnd Bergmann <arnd@arndb.de>
