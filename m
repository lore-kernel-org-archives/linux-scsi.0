From: Andrew Morton <akpm@osdl.org>
Subject: Re: bug 2400
Date: Thu, 1 Apr 2004 14:08:01 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040401140801.364bcbb1.akpm@osdl.org>
References: <20040401131502.41136788.akpm@osdl.org>
	<1080856352.5300.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:34514 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263204AbUDAWFv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2004 17:05:51 -0500
In-Reply-To: <1080856352.5300.43.camel@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: gulickconsulting@direcway.com
Cc: linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Matt Gulick <gulickconsulting@direcway.com> wrote:
>
> Remember, SCSI is not hot plugable.

oopsing the kernel is not a particularly friendly way of telling this to
our users.

If we have to bandaid over this, say, by leaking some memory and emitting
some rude printk's then OK.  Allowing the machine to kill itself,
potentially losing all the user's unsaved work is distinctly windows 95ish,
and is not OK, agree?
