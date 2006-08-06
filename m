From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: ibmvscsi on powerpc allmodconfig
Date: Mon, 07 Aug 2006 08:32:48 +0900
Message-ID: <20060807083248S.fujita.tomonori@lab.ntt.co.jp>
References: <20060805182514.94f43009.akpm@osdl.org>
	<20060806111726D.fujita.tomonori@lab.ntt.co.jp>
	<1154881285.3683.226.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:13029 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1750778AbWHFXkV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Aug 2006 19:40:21 -0400
In-Reply-To: <1154881285.3683.226.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu, akpm@osdl.org, linux-scsi@vger.kernel.org, anton@samba.org, paulus@samba.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: ibmvscsi on powerpc allmodconfig
Date: Sun, 06 Aug 2006 11:21:25 -0500

> On Sun, 2006-08-06 at 11:17 +0900, FUJITA Tomonori wrote:
> > That's a target driver. Sorry, it's my fault. The problem is that the
> > scsi-target git tree on kernel.org doesn't include the latest target
> > code.
> 
> Well, probably mine too ... I thought I understood that post-OLS Mike
> Christie would take over doing the target tree on kernel.org, and so you
> wouldn't need the one I was maintaining ... is that still the plan?

Yes, it's the plan. Mike prefers that I have a git tree. So I've been
searching someone who gives it to me, however, I've not yet succeeded.
