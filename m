From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dc395x [1/6] - make functions static
Date: Tue, 26 Aug 2003 17:54:02 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030826175401.A29464@infradead.org>
References: <20030821101348.GA7570@twibble.org> <20030821101434.GB7570@twibble.org> <20030821114632.A9401@infradead.org> <20030826112235.GA8609@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:38407 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262723AbTHZQyD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2003 12:54:03 -0400
Content-Disposition: inline
In-Reply-To: <20030826112235.GA8609@twibble.org>; from lenehan@twibble.org on Tue, Aug 26, 2003 at 09:22:35PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lenehan <lenehan@twibble.org>
Cc: linux-scsi@vger.kernel.org, dc395x@twibble.org

On Tue, Aug 26, 2003 at 09:22:35PM +1000, Jamie Lenehan wrote:
> On Thu, Aug 21, 2003 at 11:46:32AM +0100, Christoph Hellwig wrote:
> [...]
> > the static belongs on the same line as the prototype.
> 
> Well... I disagree and there's no mention of it in CodingStyle...

Well, that's how the Linux core code is written and how the examples
in Documentation/CodingStyle is written.  I'll ping Linus about
explicitly mentioning it when he returns.

> but
> having said I don't actually care that much! I'll note it down in my
> list to things to change. (I'd rather do it all at once if I'm going
> to do it then one bit at a time and having a mix of styles.)

Thanks.

