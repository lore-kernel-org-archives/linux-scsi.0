From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] qla2xxx: Remove use of 'struct timeval'
Date: Wed, 25 Feb 2015 11:39:21 +0100
Message-ID: <6046940.1hi6oPJkzT@wuerfel>
References: <20150225021512.GA2837@tinar>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:59984 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbbBYKja (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Feb 2015 05:39:30 -0500
In-Reply-To: <20150225021512.GA2837@tinar>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

On Wednesday 25 February 2015 07:45:12 Tina Ruchandani wrote:
> struct register_host_info stores a 64-bit UTC system time timestamp.
> This patch removes the use of 'struct timeval' to obtain that timestamp
> as its tv_sec value will overflow on 32-bit systems in year 2038 beyond.
> The patch uses ktime_get_real_seconds() which returns a 64-bit seconds value.
> 
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>

Reviewed-by: Tina Ruchandani <ruchandani.tina@gmail.com>
