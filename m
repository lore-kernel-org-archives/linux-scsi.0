From: Andrew Morton <akpm@osdl.org>
Subject: Re: 2.6.13-mm3 (general protection fault)
Date: Thu, 15 Sep 2005 12:36:20 -0700
Message-ID: <20050915123620.0389e4aa.akpm@osdl.org>
References: <20050912024350.60e89eb1.akpm@osdl.org>
	<200509152058.13898.dominik.karall@gmx.net>
	<20050915123438.7ce4b938.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:16870 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965274AbVIOThC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 15:37:02 -0400
In-Reply-To: <20050915123438.7ce4b938.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dominik.karall@gmx.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

Andrew Morton <akpm@osdl.org> wrote:
>
> Dominik Karall <dominik.karall@gmx.net> wrote:
>  >
>  > On Monday 12 September 2005 11:43, Andrew Morton wrote:
>  > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.13/2.6.13
>  > >-mm3/
>  > 
>  > hi,
>  > again a general protection fault...
> 
>  scsi or USB I guess.
> 
>  Does the crash happen without loading any proprietary modules?

Also in 2.6.41-rc1.  See

http://bugzilla.kernel.org/show_bug.cgi?id=5265
