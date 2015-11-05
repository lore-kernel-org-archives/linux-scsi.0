From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RESEND PATCH] qla2xxx: Remove use of 'struct timeval'
Date: Thu, 05 Nov 2015 17:33:31 +0100
Message-ID: <29048575.f8WbWFRGLG@wuerfel>
References: <20151030091526.GA4028@tina-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:56903 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030549AbbKEQdj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2015 11:33:39 -0500
In-Reply-To: <20151030091526.GA4028@tina-laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, y2038@lists.linaro.org

On Friday 30 October 2015 02:15:26 Tina Ruchandani wrote:
> struct register_host_info stores a 64-bit UTC system time timestamp.
> This patch removes the use of 'struct timeval' to obtain that timestamp
> as its tv_sec value will overflow on 32-bit systems in year 2038 beyond.
> The patch uses ktime_get_real_seconds() which returns a 64-bit seconds value.
> 
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
> 

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

and picked up into my y2038 tree for now.
