From: Andrew Morton <akpm@osdl.org>
Subject: Re: [patch 17/20] enable advansys driver
Date: Thu, 27 Apr 2006 10:56:06 -0700
Message-ID: <20060427105606.21f1b27b.akpm@osdl.org>
References: <200604270934.k3R9YcKZ025485@shell0.pdx.osdl.net>
	<1146140313.2894.32.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:58506 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965015AbWD0R5s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Apr 2006 13:57:48 -0400
In-Reply-To: <1146140313.2894.32.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: arjan@infradead.org
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com

Arjan van de Ven <arjan@infradead.org> wrote:
>
> On Thu, 2006-04-27 at 02:33 -0700, akpm@osdl.org wrote:
> > From: Andrew Morton <akpm@osdl.org>
> > 
> > Apparently it works OK.  It was marked broken because:
> 
> 
> did the tester test this on a machine with > 4Gb ram ?

I doubt it.

This patch is -mm only, actually - administrative error at akpmlabs.
