From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] bfa: replace endian swap macros with the ones
 provided by linux
Date: Tue, 19 Oct 2010 16:25:21 -0400
Message-ID: <20101019202521.GA11011@infradead.org>
References: <1287447050-27777-1-git-send-email-huangj@brocade.com>
 <20101019140920.GA13348@infradead.org>
 <E5313AF6F2BFD14293E5FD0F94750F86A5CF75E89A@HQ1-EXCH01.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56681 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab0JSUZY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Oct 2010 16:25:24 -0400
Content-Disposition: inline
In-Reply-To: <E5313AF6F2BFD14293E5FD0F94750F86A5CF75E89A@HQ1-EXCH01.corp.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@Brocade.COM>
Cc: Christoph Hellwig <hch@infradead.org>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.COM>

On Tue, Oct 19, 2010 at 01:14:53PM -0700, Jing Huang wrote:
> Thanks for reviewing the patch. I tried sparse endianess checking and saw a lot of warnings, mostly
> because the structure members are still declared as unsigned int instead of using endianess annotated
> types such as __le16, __be16 and etc. Are issues like this must be fixed? I tried some other drivers
> and saw a lot of similar issues also.

Driver relaly should use proper annotations (endiness, __iomem and __user).
This helps catching all kinds of really nasty bugs using the sparse
static analysis tool.

