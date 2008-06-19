From: Greg KH <greg@kroah.com>
Subject: Re: [Security] [PATCH 0/3 2.6.27] cxgb3i: Add iSCSI driver
Date: Thu, 19 Jun 2008 10:05:49 -0700
Message-ID: <20080619170549.GA31091@kroah.com>
References: <8A71B368A89016469F72CD08050AD334D71285@maui.asicdesigners.com> <8A71B368A89016469F72CD08050AD334D7128B@maui.asicdesigners.com> <20080619065212.GA9107@kroah.com> <8A71B368A89016469F72CD08050AD33402F43B5E@maui.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40355 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbYFTDjQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2008 23:39:16 -0400
Content-Disposition: inline
In-Reply-To: <8A71B368A89016469F72CD08050AD33402F43B5E@maui.asicdesigners.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: michaelc@cs.wisc.edu, Divy Le Ray <divy@chelsio.com>, netdev@vger.kernel.org, security@kernel.org, open-iscsi@googlegroups.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Jun 19, 2008 at 08:45:43AM -0700, Karen Xie wrote:
> Greg,
> 
> We'd like to export security_inet_conn_established() from
> security/security.c.

Ok, then you need the linux-security-module@vger.kernel.org address,
which is where the linux security interface maintainer and developers
are at.  security@kernel.org is the kernel's "security team" address
where vulnerabilities and other potential problems are reported and then
fixed.

thanks,

greg k-h
