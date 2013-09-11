From: Bradley Grove <bgrove@attotech.com>
Subject: Re: [PATCH] scsi: esas2r: fix potential format string flaw
Date: Wed, 11 Sep 2013 11:38:43 -0400
Message-ID: <52308E83.3090905@attotech.com>
References: <20130911043848.GA17221@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:42736 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755028Ab3IKPit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Sep 2013 11:38:49 -0400
In-Reply-To: <20130911043848.GA17221@www.outflux.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bradley Grove <linuxdrivers@attotech.com>

On 09/11/2013 12:38 AM, Kees Cook wrote:
> This makes sure format strings cannot leak into the printk call via the
> constructed buffer.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Acked-by: Bradley Grove <bgrove@attotech.com>

Brad


