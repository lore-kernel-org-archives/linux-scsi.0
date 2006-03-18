From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] link scsi_debug later
Date: Sat, 18 Mar 2006 06:07:48 -0700
Message-ID: <20060318130748.GC8980@parisc-linux.org>
References: <20060317124407.5f19cc09.rdunlap@xenotime.net> <20060317212924.11a86800.akpm@osdl.org> <20060317221920.3c84fc65.rdunlap@xenotime.net> <20060317222738.16b94f2d.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39881 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S932098AbWCRNHx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Mar 2006 08:07:53 -0500
Content-Disposition: inline
In-Reply-To: <20060317222738.16b94f2d.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, linux-scsi@vger.kernel.org, james.bottomley@steeleye.com

On Fri, Mar 17, 2006 at 10:27:38PM -0800, Andrew Morton wrote:
> "Randy.Dunlap" <rdunlap@xenotime.net> wrote:
> >  > Is this 2.6.16 material?
> > 
> >  Well... I would say yes, I don't think it's too risky for that.
> 
> Pretty much any change is risky in this kernel :(
> 
> James, your call please.

I'm not James, but I think it's a safe change for 2.6.16.
