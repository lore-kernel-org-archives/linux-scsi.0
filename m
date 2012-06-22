From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: lpfc: problems with -Werror
Date: Fri, 22 Jun 2012 12:46:26 -0600
Message-ID: <20120622184626.GA3536@parisc-linux.org>
References: <20120621013018.GA7244@localhost> <1340265001.2985.13.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:55636 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab2FVSq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jun 2012 14:46:28 -0400
Content-Disposition: inline
In-Reply-To: <1340265001.2985.13.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Alex Iannicelli <alex.iannicelli@emulex.com>, James Smart <james.smart@emulex.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, Jun 21, 2012 at 07:50:02AM +0000, James Bottomley wrote:
> @@ -22,7 +22,9 @@
>  ccflags-$(GCOV) := -fprofile-arcs -ftest-coverage
>  ccflags-$(GCOV) += -O0
>  
> +ifdef WARNINGS_BECOME_ERRORS
>  ccflags-y += -Werror
> +endif
>  
>  obj-$(CONFIG_SCSI_LPFC) := lpfc.o

Why not more simply:

ccflags-$(WARNINGS_BECOME_ERRORS) += -Werror

> N?????r??y????b?X????v?^?)??{.n?+????{???"?{ay?
?????,j??f???h???z?
?w???
???j:+v???w?j?m????????zZ+???????j"??!

That's some nasty line noise on your modem there, James.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
