From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 2/3] iscsi iser: increase max_sectors
Date: Mon, 05 May 2008 13:43:39 -0700
Message-ID: <adabq3k1nyc.fsf@cisco.com>
References: <20080212205252.GB13643@osc.edu> <20080212205420.GD13643@osc.edu>
	<481F0D6A.9050301@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:51813 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756999AbYEEUnk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2008 16:43:40 -0400
In-Reply-To: <481F0D6A.9050301@Voltaire.COM> (Erez Zilber's message of "Mon,
	05 May 2008 16:36:42 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Erez Zilber <erezz@Voltaire.COM>
Cc: Pete Wyckoff <pw@osc.edu>, Roland Dreier <rolandd@cisco.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>

 > This could be problematic because, AFAIK, some HCAs (memfree, I think)
 > don't support FMRs of more than 2MB. Roland, am I right?

Mem-free HCAs don't support FMRs where the list of pages is bigger than
a page itself.  So yes, with 4 KB pages, you get 512 * 4 KB that way.

Of course the current iSER driver has much bigger FMR problems, since
some adapters don't support FMRs at all...

 - R.
