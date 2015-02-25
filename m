From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] [SCSI] bfa: Replace bfa_get_log_time()
Date: Wed, 25 Feb 2015 11:41:42 +0100
Message-ID: <8211611.LIRTX0Puvt@wuerfel>
References: <20150225021439.GA2819@tinar>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:53750 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbbBYKly (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Feb 2015 05:41:54 -0500
In-Reply-To: <20150225021439.GA2819@tinar>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>

On Wednesday 25 February 2015 07:44:39 Tina Ruchandani wrote:
> struct timeval will have its tv_sec field overflow on 32-bit systems
> in year 2038 and beyond. This patch removes bfa_get_log_time which
> uses struct timeval, and instead replaces calls to it with
> calls to ktime_get_real_seconds() which returns 64-bit wall-clock
> seconds.
> 
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> --
> Changes in v2:
>   - Removed call to bfa_get_log_time entirely, instead of retaining
>     it and making it call ktime_get_real_seconds internally.
>   - Made subject line more clear.

Nice!

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
