From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 0/3] cmd_filter fixes
Date: Thu, 31 Jul 2008 07:04:22 -0600
Message-ID: <20080731130422.GC30534@parisc-linux.org>
References: <6cf6b73e0807301259s309f6332wef74d2ac5bafe691@mail.gmail.com> <20080731135521N.fujita.tomonori@lab.ntt.co.jp> <20080731071851.GA30534@parisc-linux.org> <20080731162449X.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41709 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbYGaNEY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2008 09:04:24 -0400
Content-Disposition: inline
In-Reply-To: <20080731162449X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: adel.gadllah@gmail.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com, pjones@redhat.com, viro@zeniv.linux.org.uk, dougg@torque.net

On Thu, Jul 31, 2008 at 04:24:54PM +0900, FUJITA Tomonori wrote:
> > We need to be able to delete as well as add.
> 
> Yeah, I thought about adding a new file such as read_table_off.

Three files seems excessive.  Plus the +/- notation lets you do:

echo -- +0x02 +0x03 -0x08

atomically.  I don't know if that's an important feature to have.

> Looks another potential option though I prefer "-0x03" than "-03" as I
> said in the previous mail.

Makes sense.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
