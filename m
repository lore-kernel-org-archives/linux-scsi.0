From: Anton Blanchard <anton@samba.org>
Subject: Re: ppc64-sym2-fix.patch
Date: Thu, 16 Oct 2003 10:03:51 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031016000351.GA1135@krispykreme>
References: <20031015171347.GE16535@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:20371 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S262441AbTJPAG6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Oct 2003 20:06:58 -0400
Content-Disposition: inline
In-Reply-To: <20031015171347.GE16535@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Andrew Morton <akpm@zip.com.au>, linux-scsi@vger.kernel.org


Hi,

> Hi Anton.  Looks like you forgot to cc me on this one:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.0-test7/2.6.0-test7-mm1/broken-out/ppc64-sym2-fix.patch

Yeah sorry about that, I did the quick fix and havent revisited it yet.

> The comment in include/asm-ppc64/pci.h seems to indicate that it actually
> wouldn't do any harm to return success since the "hardware treats MWI
> the same as memory write".

I didnt want to because we have certain firmware workarounds that
involve setting smaller cacheline sizes. I was trying to avoid undoing
that.

As Milton here just pointed out, the generic part of the MWI code only
sets the MWI bit (which we should ignore) so we should be good to do
this. I'll test and send the ppc64 specific fix to akpm.

Anton
