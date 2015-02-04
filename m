From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: Remove use of struct timeval
Date: Wed, 04 Feb 2015 16:01:01 +0100
Message-ID: <3236510.R0yD7CL6Ln@wuerfel>
References: <20150204030448.GA3666@tinar>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:53633 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966438AbbBDPBI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Feb 2015 10:01:08 -0500
In-Reply-To: <20150204030448.GA3666@tinar>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

On Wednesday 04 February 2015 08:34:48 Tina Ruchandani wrote:
> Function stex_gettime uses 'struct timeval' whose tv_sec value
> will overflow on 32-bit systems in year 2038 and beyond. This patch
> replaces the use of struct timeval and do_gettimeofday with
> ktime_get_real_seconds, which returns a 64-bit seconds value.
> 
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>

The patch looks good, but please send it again with a proper
subject that mentions the name of the driver.

	Arnd
