From: Xi Wang <xi.wang@gmail.com>
Subject: Re: [PATCH 2/3] [SCSI] mvsas: fix shift in mvs_94xx_free_reg_set()
Date: Fri, 09 Nov 2012 08:44:21 -0500
Message-ID: <509D08B5.2080303@gmail.com>
References: <1352145183-29355-1-git-send-email-xi.wang@gmail.com>  <1352145183-29355-3-git-send-email-xi.wang@gmail.com> <1352203618.2529.22.camel@dabdike> <50997955.10000@gmail.com> <F766E4F80769BD478052FB6533FA745D25EA5FB180@SC-VEXCH4.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61459 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab2KINoY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Nov 2012 08:44:24 -0500
In-Reply-To: <F766E4F80769BD478052FB6533FA745D25EA5FB180@SC-VEXCH4.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 11/9/12 2:30 AM, Xiangliang Yu wrote:
> Agree with James, and just need to do NOT operation one time

Thanks for reviewing the patches.

Okay I'll remove patch 2 in v2 then.

> About patch 3, I check the ffz code and found it will check ~0 conditions.

Can you point me to the ~0 check in ffz code?  I also feel like using
__ffs64 makes the code simpler.

Does patch 1 look good to you?  Thanks.

- xi
