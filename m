From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] 2.6.2, Partition support for SCSI CDROM...
Date: Fri, 27 Feb 2004 09:51:54 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040226225419.27FFA2C363@lists.samba.org>
References: <20040224170626.A25066@infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:43215 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S261231AbUBZWyJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Feb 2004 17:54:09 -0500
In-reply-to: Your message of "Tue, 24 Feb 2004 17:06:26 -0000."
             <20040224170626.A25066@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Steven J. Hill" <sjhill@realitydiluted.com>, Jeremy Higdon <jeremy@sgi.com>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

In message <20040224170626.A25066@infradead.org> you write:
> +MODULE_PARM(partitions, "i");
> 
> please make this module_param so it works at boot-time aswell.

But beware: there's another MODULE_PARM in the same module.  You can't
mix them, you'll need to find and fix that too.

Thanks,
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
