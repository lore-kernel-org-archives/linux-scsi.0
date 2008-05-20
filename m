From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 2/3][-mm] reclassify the sg_sysfs_class mutex
Date: Tue, 20 May 2008 10:22:59 -0700
Message-ID: <20080520172259.GB11666@kroah.com>
References: <20080520095851.GB3201@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37788 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765233AbYETRZ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 May 2008 13:25:57 -0400
Content-Disposition: inline
In-Reply-To: <20080520095851.GB3201@darkstar.te-china.tietoenator.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Young <hidave.darkstar@gmail.com>
Cc: akpm@linux-foundation.org, matthew@wil.cx, kay.sievers@vrfy.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 05:58:51PM +0800, Dave Young wrote:
> [Please first apply the patch 1/3 before this]
> 
> To please lockdep here we use class_reclassify to change
> the lock class of sg_sysfs_class

Are you suggesting we do this for every struct class in the kernel?  If
so, why not just do it in the class core, instead of having to modify
every single caller?

I don't think the overall idea of this patch set is acceptable anyway :(

thanks,

greg k-h
