From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Thu, 26 Nov 2009 09:26:59 +0900
Message-ID: <20091126092646I.fujita.tomonori@lab.ntt.co.jp>
References: <bug-14563-11613@http.bugzilla.kernel.org/>
	<200911251651.nAPGpPdg001386@demeter.kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:57126 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759995AbZKZA1B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Nov 2009 19:27:01 -0500
In-Reply-To: <200911251651.nAPGpPdg001386@demeter.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@jmbreuer.net

On Wed, 25 Nov 2009 16:51:25 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=14563
> 
> 
> 
> 
> 
> --- Comment #22 from Joachim Breuer <linux-kernel@jmbreuer.net>  2009-11-25 16:51:21 ---
> OK, reading back the tape from #21 yields no verify errors; it seems writing
> with FUJITA Tomonori's patch works correctly for me.

Thanks a lot!

And really sorry about the bug.
