From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v5] cmdfilter: clean up sysfs interface
Date: Sat, 9 Aug 2008 07:55:21 -0600
Message-ID: <20080809135520.GJ8618@parisc-linux.org>
References: <6cf6b73e0808081456g7d50f66dvc98f5b42a6bab65b@mail.gmail.com> <20080809033935.GI8618@parisc-linux.org> <6cf6b73e0808090309y94a071dh3079d4e89cc1154f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52385 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbYHINzh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Aug 2008 09:55:37 -0400
Content-Disposition: inline
In-Reply-To: <6cf6b73e0808090309y94a071dh3079d4e89cc1154f@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adel Gadllah <adel.gadllah@gmail.com>
Cc: linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, viro@zeniv.linux.org.uk, Peter Jones <pjones@redhat.com>, dougg@torque.net, dan.j.williams@intel.com, James.Bottomley@hansenpartnership.com

On Sat, Aug 09, 2008 at 12:09:38PM +0200, Adel Gadllah wrote:
> ------------------------
> This patch changes the interface of the cmd filter to use a +/- notation like:
> echo -- +0x02 +0x03 -0x08
> If neither + or - is given it defaults to + (allow command).
> 
> Note: The interface was added in 2.6.17-rc1 and is unused
> and undocumented so far so it's safe to change it.
> 
> Cc: matthew@wil.cx
> Cc: fujita.tomonori@lab.ntt.co.jp
> Cc: jens.axboe@oracle.com
> Cc: James.Bottomley@hansenpartnership.com
> Cc: dan.j.williams@intel.com
> Cc: pjones@redhat.com
> Cc: viro@zeniv.linux.org.uk
> Cc: dougg@torque.net
> Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>



-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
