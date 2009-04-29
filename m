From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH -next] osd_uld: fix printk format warning
Date: Wed, 29 Apr 2009 19:51:28 +0100
Message-ID: <20090429185128.GN8633@ZenIV.linux.org.uk>
References: <20090429092631.a76e79c5.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:60343 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbZD2Sv3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2009 14:51:29 -0400
Content-Disposition: inline
In-Reply-To: <20090429092631.a76e79c5.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Apr 29, 2009 at 09:26:31AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format warnings in osd_uld:
> 
> drivers/scsi/osd/osd_uld.c:191: warning:format '%s' expects type 'char *', but argument 2 has type 'struct path'
> 
> Also fix a small typo.

Applied, will fold on reorder.  Thanks for catching that one and apologies
for missing the original posting (I am subscribed to linux-scsi, but...)

Incidentally, what the hell is going with ->i_cdev in there?  Boaz?
