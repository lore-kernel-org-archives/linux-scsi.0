From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SCSI won't compile with PROC enabled on 2.6.0-test5
Date: Wed, 24 Sep 2003 20:09:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030924200954.A23837@infradead.org>
References: <1064429833.13033.316.camel@persist.az.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:30479 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261620AbTIXTJz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2003 15:09:55 -0400
Content-Disposition: inline
In-Reply-To: <1064429833.13033.316.camel@persist.az.mvista.com>; from sdake@mvista.com on Wed, Sep 24, 2003 at 11:57:13AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Steven Dake <sdake@mvista.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Sep 24, 2003 at 11:57:13AM -0700, Steven Dake wrote:
> The compile result is:

That looks very strange..  I don't have plain 2.6.0-test5 around
here, but current BK compiles fine.  Not that I disabled procfs
previously :)

Can you reproduce this with a stock current tree or latest -bk
snapshot?

