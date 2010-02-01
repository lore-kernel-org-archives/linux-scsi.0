From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 05/10] drivers/scsi/arcmsr: Fix continuation line
 formats
Date: Mon, 01 Feb 2010 09:30:22 -0800
Message-ID: <1265045422.25140.289.camel@Joe-Laptop.home>
References: <cover.1264967493.git.joe@perches.com>
	 <1a318fa326c6ab2584b9d318bd1538e7f7debbdf.1264967499.git.joe@perches.com>
	 <1265044616.6910.15.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1699 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab0BARaX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2010 12:30:23 -0500
In-Reply-To: <1265044616.6910.15.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 2010-02-01 at 11:16 -0600, James Bottomley wrote:
> On Sun, 2010-01-31 at 12:02 -0800, Joe Perches wrote: 
> > String constants that are continued on subsequent lines with \
> > are not good.
> 
> Why?  It's perfectly valid ansi C.

Because they generally add unwanted spaces or tabs between
words in logging messages.  Just like these do.

> but I also dislike your solution; I'd have split the string into two
> separate ones and relied on compiler concatenation.

Which Linus dislikes because it makes grepping difficult.

> However, the point is that all three are perfectly legal C.  Choosing
> one form over another is something best left to the maintainers rather
> than imposing one style by fiat.

Which a patch does not do.

> Consider this change veto'd unless you can get an explicit ack from the
> current maintainer for changing their style.

The current messages are defective.

