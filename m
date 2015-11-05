From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [Y2038] [RESEND PATCH] [SCSI] mvumi: 64bit value for seconds_since1970
Date: Thu, 05 Nov 2015 17:31:59 +0100
Message-ID: <14019194.YcEYYbidsv@wuerfel>
References: <20151030091110.GA3880@tina-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:62822 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162222AbbKEQcJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2015 11:32:09 -0500
In-Reply-To: <20151030091110.GA3880@tina-laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: y2038@lists.linaro.org
Cc: Tina Ruchandani <ruchandani.tina@gmail.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

On Friday 30 October 2015 02:11:10 Tina Ruchandani wrote:
> struct mvumi_hs_page2 stores a "seconds_since1970" field which is of
> type u64. It is however, written to, using 'struct timeval' which has
> a 32-bit seconds field and whose value will overflow in year 2038.
> This patch uses ktime_get_real_seconds() instead since it provides a
> 64-bit seconds value, which is 2038 safe.
> 
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
> ---

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

and picked up into my y2038 tree temporarily until it shows up in scsi.
