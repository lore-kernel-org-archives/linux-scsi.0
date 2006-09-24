From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] async scsi scanning, version 11
Date: Sun, 24 Sep 2006 13:42:55 -0700
Message-ID: <20060924134255.74a270dc.rdunlap@xenotime.net>
References: <20060924190623.GB2595@parisc-linux.org>
	<20060924130253.48f90fe5.rdunlap@xenotime.net>
	<20060924204000.GE2595@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:60897 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S932080AbWIXUln (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Sep 2006 16:41:43 -0400
Received: from midway.site ([71.117.233.155]) by xenotime.net for <linux-scsi@vger.kernel.org>; Sun, 24 Sep 2006 13:41:41 -0700
In-Reply-To: <20060924204000.GE2595@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Sun, 24 Sep 2006 14:40:01 -0600 Matthew Wilcox wrote:

> > > +struct async_scan_data * scsi_prep_async_scan(struct Scsi_Host *shost)
> > 
> > whitespace violation (*scsi_prep_async_scan)
> 
> Hmm?  Wouldn't that be a function pointer?  Did you mean to say I should
> use:
> 
> struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
> 
> ?  I don't particularly mind either way.

yes, sorry about the shorthand.

---
~Randy
