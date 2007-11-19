From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Bugme-new] [Bug 9405] New: iSCSI does not implement ordering guarantees required by e.g. journaling filesystems
Date: Mon, 19 Nov 2007 14:18:54 -0700
Message-ID: <20071119211854.GG12494@parisc-linux.org>
References: <bug-9405-10286@http.bugzilla.kernel.org/> <20071119125040.9f6eb1e2.akpm@linux-foundation.org> <4741FCEA.4040101@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38482 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbXKSVS4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2007 16:18:56 -0500
Content-Disposition: inline
In-Reply-To: <4741FCEA.4040101@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, bart.vanassche@gmail.com

On Mon, Nov 19, 2007 at 03:15:22PM -0600, Mike Christie wrote:
> +iSCSI

It's traditional to use all-caps here, even when the normal
capitalisation is different.  so I think this should be "ISCSI".
Damned if I know why we have this convention, though.

> +P:	Mike Christie
> +M:	michaelc@cs.wisc.edu
> +L:	open-iscsi@googlegroups.com
> +W:	www.open-iscsi.org
> +T:	git kernel.org:/pub/scm/linux/kernel/mnc/linux-2.6-iscsi.git
> +S:	Maintained


-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
