From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH 0/5] scsi: use platform helper macro and wrapper functions
Date: Fri, 31 May 2013 09:15:51 +0800
Message-ID: <51A7F9C7.3080404@huawei.com>
References: <1369915786-2660-1-git-send-email-wangkefeng.wang@huawei.com> <1369924699.1972.4.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:5017 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab3EaBQc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 May 2013 21:16:32 -0400
In-Reply-To: <1369924699.1972.4.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "David S. Miller" <davem@davemloft.net>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, guohanjun@huawei.com

On 2013-05-30 22:38, James Bottomley wrote:
> There doesn't seem to be much point to these patches since either idiom
> is fine and easily understood.  We also try to touch the ancient drivers
> as little as possible since it can be months before anyone actually
> tries them out and notices that something got broken, so the rule for
> them is obvious bug fixes only.
> 
> James

hi James,
Thanks for remind, I got it.



