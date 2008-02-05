From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 4 Feb 2008 17:20:57 -0800 (PST)
Message-ID: <alpine.LFD.1.00.0802041718140.3237@woody.linux-foundation.org>
References: <47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net> <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net> <1202144767.3096.38.camel@localhost.localdomain> <47A7488B.4080000@vlnb.net> <1202145901.3096.49.camel@localhost.localdomain>
 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org> <1202151989.11265.576.camel@haakon2.linux-iscsi.org> <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org> <20080204210121.GF18682@fieldses.org> <alpine.LFD.1.00.0802041317280.3034@hp.linux-foundation.org>
 <47A7986B.1070206@garzik.org> <alpine.LFD.1.00.0802041530150.3034@hp.linux-foundation.org> <47A7A903.1060000@garzik.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757268AbYBEBVi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 20:21:38 -0500
In-Reply-To: <47A7A903.1060000@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Bart Van Assche <bart.vanassche@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>



On Mon, 4 Feb 2008, Jeff Garzik wrote:
> 
> Both of these are easily handled if the server is 100% in charge of managing
> the filesystem _metadata_ and data.  That's what I meant by complete control.
> 
> i.e. it not ext3 or reiserfs or vfat, its a block device or 1000GB file
> managed by a userland process.

Oh ok.

Yes, if you bring the filesystem into user mode too, then the problems go 
away - because now your NFSD can interact directly with the filesystem 
without any kernel/usermode abstraction layer rules in between. So that 
has all the same properties as moving NFSD entirely into the kernel.

			Linus
