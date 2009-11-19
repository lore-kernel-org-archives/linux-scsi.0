From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Thu, 19 Nov 2009 16:50:58 +0900
Message-ID: <20091119165048D.fujita.tomonori@lab.ntt.co.jp>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
	<200911181653.nAIGrr9M024422@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:41002 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbZKSHvD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2009 02:51:03 -0500
In-Reply-To: <200911181653.nAIGrr9M024422@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@jmbreuer.net

On Wed, 18 Nov 2009 16:53:53 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=14563
> 
> 
> 
> 
> 
> --- Comment #15 from Joachim Breuer <linux-kernel@jmbreuer.net>  2009-11-18 16:53:53 ---
> Allright! You hit something on the head!
> 
> With 'try_rdio=0 try_wdio=0' as parameters to the st module, writing to tape
> from amanda works correctly in 2.6.30.3.

Thanks a lot for the logs. They are very helpful.

I think that I found one bug about dio. There might be other bugs that
cause this issue though.

Can you try the patch that I've just sent.

Thanks,
