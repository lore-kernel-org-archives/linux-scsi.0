From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/3] cmd_filter fixes
Date: Fri, 1 Aug 2008 00:18:37 +0900
Message-ID: <20080801001839L.tomof@acm.org>
References: <20080731071851.GA30534@parisc-linux.org>
	<20080731162449X.fujita.tomonori@lab.ntt.co.jp>
	<20080731130422.GC30534@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:56536 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbYGaPTW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2008 11:19:22 -0400
In-Reply-To: <20080731130422.GC30534@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: fujita.tomonori@lab.ntt.co.jp, adel.gadllah@gmail.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com, pjones@redhat.com, viro@zeniv.linux.org.uk, dougg@torque.net

On Thu, 31 Jul 2008 07:04:22 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Thu, Jul 31, 2008 at 04:24:54PM +0900, FUJITA Tomonori wrote:
> > > We need to be able to delete as well as add.
> > 
> > Yeah, I thought about adding a new file such as read_table_off.
> 
> Three files seems excessive.  Plus the +/- notation lets you do:
> 
> echo -- +0x02 +0x03 -0x08

I like it. This interface can handle both multiple changes and a
single change nicely.
