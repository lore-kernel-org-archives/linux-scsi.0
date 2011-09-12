From: Christoph Hellwig <hch@infradead.org>
Subject: Re: system freezing with 3.0.4
Date: Mon, 12 Sep 2011 16:16:06 -0400
Message-ID: <20110912201606.GA24927@infradead.org>
References: <4E69A496.9040707@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44769
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041Ab1ILUQJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2011 16:16:09 -0400
Content-Disposition: inline
In-Reply-To: <4E69A496.9040707@profihost.ag>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: LKML <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

On Fri, Sep 09, 2011 at 07:31:02AM +0200, Stefan Priebe - Profihost AG wrote:
> Hi list,
> 
> here's an updated post of my one yesterday.
> 
> We've updated some systems from 2.6.32 to 3.0.4 vanilla kernel.
> Since then we're expecting freezes every now and then. All in memory
> apps are still working but nothing which reads or writes from or to
> disk (at least it seems like that).

What storage driver(s) do you use?

