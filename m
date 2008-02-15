From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Sat, 16 Feb 2008 01:09:43 +0900
Message-ID: <20080216010954M.tomof@acm.org>
References: <20080214235549.GA19591@tpepper-t42p.dolavim.us>
	<20080215091316H.fujita.tomonori@lab.ntt.co.jp>
	<20080215011636.GA21124@tpepper-t42p.dolavim.us>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:39209 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbYBOQkL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 11:40:11 -0500
In-Reply-To: <20080215011636.GA21124@tpepper-t42p.dolavim.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lnxninja@linux.vnet.ibm.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com, tomof@acm.org

On Thu, 14 Feb 2008 17:16:36 -0800
Tim Pepper <lnxninja@linux.vnet.ibm.com> wrote:

> On Fri 15 Feb at 09:13:16 +0900 fujita.tomonori@lab.ntt.co.jp said:
> > 
> > Thanks. So we surely have a bug in the non-breakup part.
> > 
> > I've just found one bug. Can you try this patch against 2.6.24?
> 
> Tested and unfortunately no change.  Behaves same as the breakup-revert patch.

Thanks and sorry about that.

Now I don't have any idea. I split the patch. Can you please apply
them in a step-by-step way and tell me which patch breaks the driver?

There are nine patches against 2.6.24:

http://www.kernel.org/pub/linux/kernel/people/tomo/ips/

The first one is just reverting the data buffer accessors
conversion. It would be nice if we could just revert it but we
can't. These changes are necessary to compile the driver against post
2.6.24.

Really sorry about the troubles,
