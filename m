From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH][2.6.8-rc1-mm1] drivers/scsi/sg.c gcc341 inlining fix
Date: Wed, 14 Jul 2004 19:39:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F5C42E.1060708@pobox.com>
References: <200407141751.i6EHprhf009045@harpo.it.uu.se>	<40F57D14.9030005@pobox.com> <20040714143508.3dc25d58.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:43738 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265124AbUGNXjl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jul 2004 19:39:41 -0400
In-Reply-To: <20040714143508.3dc25d58.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Andrew Morton wrote:
> Yeah, but doing:
> 
> 	static inline foo(void);
> 
> 	bar()
> 	{
> 		...
> 		foo();
> 	}
> 
> 	static inline foo(void)
> 	{
> 		...
> 	}
> 
> is pretty dumb too.  I don't see any harm if this compiler feature/problem
> pushes us to fix the above in the obvious way.


???  C does not require ordering of function _implementations_, except 
for this gcc brokenness.

The above example allows one to do what one normally does with 
non-inlines:  order code to enhance readability, and the compiler will 
Do The Right Thing and utilize it in the best way the CPU will function.

Just because you stick a modifier on a function doesn't mean it's time 
to stop using C as it was meant to be used :)

	Jeff


