From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] update sd to use kref and fix open/release race
Date: Fri, 9 Apr 2004 12:32:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040409193238.GA17841@kroah.com>
References: <1081518779.2203.29.camel@mulgrave> <20040409095657.A2970@beaverton.ibm.com> <20040409101729.A3121@beaverton.ibm.com> <1081538374.2202.157.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kroah.org ([65.200.24.183]:21707 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S261611AbUDITcz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2004 15:32:55 -0400
Content-Disposition: inline
In-Reply-To: <1081538374.2202.157.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Apr 09, 2004 at 02:19:34PM -0500, James Bottomley wrote:
> 
> Really, we need to make dev_printk a lot more robust if it's actually
> going to be useful.

It is useful, you just have to be careful in how you use it :)

I have a debugging patch in my kernel tree that checks and prevents
oopses in those calls, but I've been told that it will not make it into
the main kernel tree.

thanks,

greg k-h
