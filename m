From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Tue, 19 Feb 2008 17:22:34 +0900
Message-ID: <20080219172234N.fujita.tomonori@lab.ntt.co.jp>
References: <20080218233057.GC12905@tpepper-t42p.dolavim.us>
	<20080219091121I.fujita.tomonori@lab.ntt.co.jp>
	<eada2a070802181948p782a4862p3bc08db7b2b64beb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:34903 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbYBSIWw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Feb 2008 03:22:52 -0500
In-Reply-To: <eada2a070802181948p782a4862p3bc08db7b2b64beb@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lnxninja@linux.vnet.ibm.com
Cc: fujita.tomonori@lab.ntt.co.jp, tomof@acm.org, linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.com

On Mon, 18 Feb 2008 19:48:49 -0800
"Tim Pepper" <lnxninja@linux.vnet.ibm.com> wrote:

> On Feb 18, 2008 4:11 PM, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > Can you please help me just once more? 2.6.25-rc2 fixed this bug in a
> > bit different way by chance. Please test 2.6.25-rc2 with the attached
> > patch to make sure that ips in 2.6.25 works well.
> 
> Confirmed...the patch below against 2.6.25-rc2 also works for me.

Thanks a lot!

I'll make sure that the ips driver in 2.6.23-stable, 2.6.24-stable
(and 2.6.25) will work well.
