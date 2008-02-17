From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Mon, 18 Feb 2008 07:31:56 +0900
Message-ID: <20080218073134A.tomof@acm.org>
References: <20080215225057.GA3172@tpepper-t42p.dolavim.us>
	<20080216094127E.tomof@acm.org>
	<20080217211539.GA29813@tpepper-t42p.dolavim.us>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:32867 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950AbYBQWnt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Feb 2008 17:43:49 -0500
In-Reply-To: <20080217211539.GA29813@tpepper-t42p.dolavim.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lnxninja@linux.vnet.ibm.com
Cc: tomof@acm.org, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com

On Sun, 17 Feb 2008 13:15:40 -0800
Tim Pepper <lnxninja@linux.vnet.ibm.com> wrote:

> On Sat 16 Feb at 09:41:48 +0900 tomof@acm.org said:
> > 
> > Do you mean that you applied only the following two patches against
> > 2.6.24, and then it doesn't work?
> > 
> > 0001-ips-revert-the-changes-for-the-data-buffer-accessor.patch
> 
> I only applies the 0001 patch and the driver appeared to function fine.

I see, thanks. It would be nice if we can push only the 0001 patch to
mainline, however as I explained, we can't unfortunately. The
0002-0009 patches are necessary for post 2.6.24.


> > If so, the second patch is broken. Did you saw BUG_ON message (I added
> > some BUG_ON to the patch)?
> 
> I did not apply the 0002 patch.

Can you apply the 0001 and 0002 against 2.6.24 and see how it works?
If it works well, then please apply the 0001, 0002 and 0003.

Please the patches in a step-by-step way and tell me which patch
breaks the driver.

Thanks,
