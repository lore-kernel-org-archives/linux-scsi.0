From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2.6.25.1] Add scsi_execute_async_fifo()
Date: Fri, 2 May 2008 10:49:06 -0600
Message-ID: <20080502164905.GH14976@parisc-linux.org>
References: <200805021638.42972.bart.vanassche@gmail.com> <20080502153306.GB7376@infradead.org> <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com> <20080502155525.GA16353@infradead.org> <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com> <20080502161629.GF14976@parisc-linux.org> <e2e108260805020923wc7a9e0bl539eaa386d8410bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39364 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758797AbYEBQtH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 12:49:07 -0400
Content-Disposition: inline
In-Reply-To: <e2e108260805020923wc7a9e0bl539eaa386d8410bb@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel@lists.sourceforge.net

On Fri, May 02, 2008 at 06:23:08PM +0200, Bart Van Assche wrote:
> Which target code is already in the mainline kernel, and who are the
> maintainers for this code ? I checked the MAINTAINERS file in the
> 2.6.25 tarball, but in this file I could not find the information I
> was looking for.

Can you really not locate drivers/scsi/scsi_tgt_lib.c in the tree?  I
appreciate that there's a lot of files in the drivers/scsi/ directory,
but c'mon.  I had no idea what it was called and it took about 30
seconds to find them once I realised you wanted all the work to be done
for you.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
