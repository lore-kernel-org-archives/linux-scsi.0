From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Linux support for the LSI SAS8208ELP
Date: Fri, 31 Dec 2010 10:52:00 -0700
Message-ID: <20101231175200.GA32652@parisc-linux.org>
References: <4D1E0831.8090602@digadd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42349 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab0LaRwD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Dec 2010 12:52:03 -0500
Content-Disposition: inline
In-Reply-To: <4D1E0831.8090602@digadd.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christian Schmidt <charlie@digadd.de>
Cc: Eric Moore <Eric.Moore@lsi.com>, support@lsi.com, linux-scsi@vger.kernel.org

On Fri, Dec 31, 2010 at 05:43:29PM +0100, Christian Schmidt wrote:
> Since LSI seems to only provide closed source drivers for far obsolete
> and limited "enterprise" distribution kernels I'd suggest the inclusion
> of the PCI IDs into the kernel.

http://marc.info/?l=linux-scsi&m=129019864003449&w=2

(ok, 0x55 vs 0x59, but dollars-to-doughnuts it's the same 'problem')

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
