From: "David S. Miller" <davem@davemloft.net>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Wed, 28 Sep 2005 16:29:29 -0700 (PDT)
Message-ID: <20050928.162929.50617923.davem@davemloft.net>
References: <433B0374.4090100@adaptec.com>
	<20050928223542.GA12559@alpha.home.local>
	<433B25CD.7040809@pobox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751239AbVI1XaU@vger.kernel.org>
In-Reply-To: <433B25CD.7040809@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: willy@w.ods.org, luben_tuikov@adaptec.com, andre@linux-ide.org, patmans@us.ibm.com, ltuikov@yahoo.com, linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Jeff Garzik <jgarzik@pobox.com>
Date: Wed, 28 Sep 2005 19:22:53 -0400

> Both Luben and his predecessor, Justin Gibbs, were severely dissatisfied 
> with the SCSI core.  Often they have raised valid issues that need 
> addressing, but their choice has been to work around or ignore existing 
> code (and maintainers), rather than work with it, and fix it.

I'm in violent agreement here.

Justin was just as anti-social of an engineer as one could get.  And,
when you put an ex-FreeBSD guy onto Linux driver maintainence, what in
the world could anyone expect. :-)

For example, instead of accepting that the symbol "current" is a
reserved symbol when compiling under the Linux kernel, he decided that
"sticking a square peg into a round hole" was a better way to deal
with this, and thus he put an "#undef current" into the adaptec driver
instead of simply renaming a structure member from "current" to
something else.

I don't know how else to define "control freak".
