From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Removing BROKEN scsi drivers
Date: Wed, 5 Oct 2005 05:31:08 -0600
Message-ID: <20051005113108.GA19437@parisc-linux.org>
References: <200510051314.33411.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:32682 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S965112AbVJELbK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Oct 2005 07:31:10 -0400
Content-Disposition: inline
In-Reply-To: <200510051314.33411.ak@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: linux-scsi@vger.kernel.org, richard@sleepie.demon.co.uk

On Wed, Oct 05, 2005 at 01:14:32PM +0200, Andi Kleen wrote:
> SCSI_AMIGA7XX - no maintainer, broken forever
> MVME16x_SCSI - no maintainer, broken forever
> BVME6000_SCSI - same

I don't think there's any point in deleting these.  I'm not even sure
why they're marked BROKEN.  They share 99% of their code with drivers
which are working.  And I thought Richard Hirst was maintaining them ...
