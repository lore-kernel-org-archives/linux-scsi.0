From: Christoph Hellwig <hch@lst.de>
Subject: Re: scsi: add support for a blk-mq based I/O path.
Date: Tue, 16 Sep 2014 20:02:37 +0200
Message-ID: <20140916180237.GA16649@lst.de>
References: <54184C09.70800@linuxbox.com> <20140916161914.GA2756@lst.de> <541870C3.9020607@linuxbox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37135 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250AbaIPSCk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Sep 2014 14:02:40 -0400
Content-Disposition: inline
In-Reply-To: <541870C3.9020607@linuxbox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Gryniewicz <dang@linuxbox.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Sep 16, 2014 at 01:17:55PM -0400, Daniel Gryniewicz wrote:
>> this should also be fixed with my patch "scsi: clean up S/G table freeing",
>> can you test if that fixes the issue for you as well?
>>
>
>
> Yeah, that fixes it, thanks.

Thanks. Looking at the impact of that I suspect we're better off merging
your version for 3.17.

Can I get another review for it from someone, please?

