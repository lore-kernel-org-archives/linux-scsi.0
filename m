From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block
	pc	requests	and simplify hw handlers
Date: Tue, 07 Jun 2005 15:26:34 -0400
Message-ID: <1118172394.4791.9.camel@mulgrave>
References: <1117847972.23638.62.camel@mina>
	 <1117901234.5005.9.camel@mulgrave> <1117955727.4961.8.camel@mina>
	 <1117982408.4990.12.camel@mulgrave> <1117998665.4990.17.camel@mulgrave>
	 <42A3E275.6030106@torque.net> <1118067544.5045.17.camel@mulgrave>
	 <42A59C35.5060207@torque.net> <1118159966.4813.8.camel@mulgrave>
	 <20050607180719.GB8172@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:63429 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261981AbVFGUnO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jun 2005 16:43:14 -0400
In-Reply-To: <20050607180719.GB8172@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Douglas Gilbert <dougg@torque.net>, Mike Christie <michaelc@cs.wisc.edu>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, LIRANS@il.ibm.com

On Tue, 2005-06-07 at 20:07 +0200, Jens Axboe wrote:
> Why multi-bio? No one should ever have to build a request with multiple
> bio's in one go, that's pointless. The only reason multi-bio requests
> exist is because of the file systems not submitting big extents in one
> submission. The whole io path would be faster and simpler were it not
> for multi-bio requests :-)

OK, OK, sorry thinko ... I meant multi-biovec (which can be a single
bio) ... however, I'm not the only one who keeps being confused by
this ...

Incidentally, do I take it you're happy with all of this and I can take
(at least the block pieces) through the SCSI tree?

Mike, I won't taking the dm-multipath patch unless there's agreement
from Alasdair.

James


