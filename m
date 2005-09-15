From: adam radford <aradford@gmail.com>
Subject: Re: Hardware RAID problem
Date: Thu, 15 Sep 2005 15:26:45 -0700
Message-ID: <b1bc6a00050915152657ebb321@mail.gmail.com>
References: <dgcpuo$n6a$1@sea.gmane.org>
Reply-To: aradford@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xproxy.gmail.com ([66.249.82.200]:2327 "EHLO xproxy.gmail.com")
	by vger.kernel.org with ESMTP id S965291AbVIOW0q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 18:26:46 -0400
Received: by xproxy.gmail.com with SMTP id i27so270244wxd
        for <linux-scsi@vger.kernel.org>; Thu, 15 Sep 2005 15:26:45 -0700 (PDT)
In-Reply-To: <dgcpuo$n6a$1@sea.gmane.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Byer <ojbyer@usa.net>
Cc: linux-scsi@vger.kernel.org

Jack,

There was a bug in 3w-9xxx that became apparent with the latest scsi-block-2.6
merge.  Can you re-test the 3ware 9000 with 2.6.14-rc1?

-Adam

On 9/15/05, Jack Byer <ojbyer@usa.net> wrote:
> Last week, I reported a problem booting my machine with a AMI megaraid
> card. This problem appeared on -mm kernels >= 2.6.12-mm1 and on
> 2.6.14-rc1. I tried applying a patch from Christoph Hellwig, which did
> not resolve the problem.
> 
> Now I am seeing the exact same bug on a different machine, using a
> different raid controller (3ware 9xxx series) when trying to install
> 2.6.13-mm1.
> 
> Is there any chance that this is a kernel configuration problem, or has
> something recently changed in the scsi drivers that is affecting both
> drivers?
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
