From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 0/4] more gdth patches for your amusement
Date: Sat, 21 Jul 2007 16:38:44 -0400
Message-ID: <46A26ED4.10405@garzik.org>
References: <20070721203410.GA1004@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:34177 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759845AbXGUUiw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jul 2007 16:38:52 -0400
In-Reply-To: <20070721203410.GA1004@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, achim_leubner@adaptec.com, Andrew Morton <akpm@linux-foundation.org>

Jeff Garzik wrote:
> This is the rest of the stuff checked into the 'gdth' branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git
> 
> As noted before, I'm fine with Christoph's gdth work superceding mine,
> or whatever.  This was just me poking around.  Hopefully the patches
> are useful for illustration, if nothing else.

Illustrating, of course, a guarantee-nothing-breaks, bug-for-bug code 
movement approach to upgrading the driver.

It intentionally avoids cleanups along the way, other than those 
explicitly enumerated, to preserve as much behavior as possible (and 
thus reduce chances of breakage as much as possible).

	Jeff



