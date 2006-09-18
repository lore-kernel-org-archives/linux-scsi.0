From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] aic94xx: Compile problem on s390
Date: Mon, 18 Sep 2006 13:21:38 -0600
Message-ID: <20060918192138.GR2585@parisc-linux.org>
References: <20060918191545.GA10525@krzeszut.users.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:22415 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1751783AbWIRTVj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 15:21:39 -0400
Content-Disposition: inline
In-Reply-To: <20060918191545.GA10525@krzeszut.users.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek <konradr@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, alexisb@us.ibm.com

On Mon, Sep 18, 2006 at 03:15:45PM -0400, Konrad Rzeszutek wrote:
> The aic94xx driver in my-scsi and aic94xx James Bottomley tree does not
> compile on s390. Since the driver is generic, it makes sense to fix.

Erm, well, I don't think there's any s390s with PCI ;-)

> The patch is quite simple:
> +#include <asm/scatterlist.h>

Surely should be linux/scatterlist.h?
