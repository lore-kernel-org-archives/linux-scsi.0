From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC 3/6] bidi support: bidirectional request
Date: Mon, 22 Jan 2007 09:00:21 -0600
Message-ID: <1169478021.2769.5.camel@mulgrave.il.steeleye.com>
References: <45B3F64C.3030805@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:47655 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751878AbXAVPBb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2007 10:01:31 -0500
In-Reply-To: <45B3F64C.3030805@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com, Daniel.E.Messinger@seagate.com, Liran Schour <LIRANS@il.ibm.com>, Benny Halevy <bhalevy@panasas.com>

On Mon, 2007-01-22 at 01:25 +0200, Boaz Harrosh wrote:
> - Instantiate another request_io_part in request for bidi_read.
> - Define & Implement new API for accessing bidi parts.
> - API to Build bidi requests and map to sglists.
> - Define new end_that_request_block() function to end a complete request.

Actually, this approach looks to be a bit too narrow.  You seem to be
predicating on the idea that the bidirectional will transfer in and out
of the same area.  For some of the frame in/frame out stuff, we probably
need the read and write areas for the bidirectional request to be
separated.

James


