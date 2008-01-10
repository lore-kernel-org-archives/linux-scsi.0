From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Driver 'sd' needs updating
Date: Thu, 10 Jan 2008 20:38:45 +0900
Message-ID: <20080110203845E.fujita.tomonori@lab.ntt.co.jp>
References: <20080110085150.53addacf@linuxamd.linicks.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:50222 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbYAJLjF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2008 06:39:05 -0500
In-Reply-To: <20080110085150.53addacf@linuxamd.linicks.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nick@ukfsn.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

CC'ed linux-scsi and James,

On Thu, 10 Jan 2008 08:51:50 +0000
Nick Warne <nick@ukfsn.org> wrote:

> 
> Hi everybody - Happy New Year to you all!
> 
> OK, updated to git rc7 yesterday - I now see this in syslog:
> 
>    "Driver 'sd' needs updating - please use bus_type methods"
> 
> The warning never appeared in RC6, and all google reveals are other
> peoples logs that are posted about other issues.
> 
> Do I need to fix up something here?

No, you don't. It's harmless, a side effect of:

commit 751bf4d7865e4ced406be93b04c7436d866d3684
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Wed Jan 2 11:14:30 2008 -0600

    [SCSI] scsi_sysfs: restore prep_fn when ULD is removed


It would be better to silence this warning.

James, we need to reset prep_fn in each ULD? though it's not nice...
