From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] proper replacements for ->proc_info
Date: 23 Apr 2003 15:29:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051126145.1970.7.camel@mulgrave>
References: <20030423212157.A18850@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:45061 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264606AbTDWTRK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Apr 2003 15:17:10 -0400
In-Reply-To: <20030423212157.A18850@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2003-04-23 at 15:21, Christoph Hellwig wrote:
> Two new host template methods:
> 
>      int (* show_info)(struct Scsi_Host *, struct seq_file *);
>      int (* store_info)(struct Scsi_Host *, const char *, size_t);


Well, this does look good, but by extension we could use something like
this as a generic way to ship information to and from sysfs as well.

How about adding a "char *property" qualifier?  If it's null you just
dump the whole lot (for /proc) but if it has a value, it's that specific
property from sysfs.

James




