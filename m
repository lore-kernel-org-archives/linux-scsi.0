From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH 4/5: scsi-scan-dont-att-pq-notcon
Date: 22 Apr 2004 16:45:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082666713.1714.109.camel@mulgrave>
References: <20040420160334.GO4356@tpkurt.garloff.de>
	<20040421134511.GP28633@tpkurt.garloff.de>
	<20040421141417.GV28633@tpkurt.garloff.de>
	<20040421160257.A6793@infradead.org>
	<20040421152436.GD29699@tpkurt.garloff.de>
	<20040421163336.A7382@infradead.org>
	<20040421160823.GK29699@tpkurt.garloff.de>
	<1082564314.1932.22.camel@mulgrave>
	<20040421095500.A17447@beaverton.ibm.com>
	<20040421225137.GE643@tpkurt.garloff.de>
	<20040422133912.A31488@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:24963 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264663AbUDVUqp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 16:46:45 -0400
In-Reply-To: <20040422133912.A31488@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Kurt Garloff <garloff@suse.de>, Christoph Hellwig <hch@infradead.org>, Linux SCSI list <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Thu, 2004-04-22 at 16:39, Patrick Mansfield wrote:
> Yes, it's minor; James hasn't replied, and there aren't any other macros
> like I'm suggesting, so go with the extra char.

Well ... I'm agnostic.  I care about the abstraction rather than the
implementation of the abstraction.  I suppose I have a slight preference
for an extra field, because that can be fixed up if there's an
identified problem with the inquiry data but I can't think of a single
case where that would be necessary.

James


