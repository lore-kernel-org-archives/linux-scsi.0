From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [RFC 3/6] bidi support: bidirectional request
Date: Tue, 23 Jan 2007 15:15:01 +0200
Message-ID: <45B60A55.6080104@panasas.com>
References: <45B3F64C.3030805@panasas.com> <1169478021.2769.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:41298 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964933AbXAWNQo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2007 08:16:44 -0500
In-Reply-To: <1169478021.2769.5.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com, Daniel.E.Messinger@seagate.com, Liran Schour <LIRANS@il.ibm.com>

James Bottomley wrote:
> On Mon, 2007-01-22 at 01:25 +0200, Boaz Harrosh wrote:
>> - Instantiate another request_io_part in request for bidi_read.
>> - Define & Implement new API for accessing bidi parts.
>> - API to Build bidi requests and map to sglists.
>> - Define new end_that_request_block() function to end a complete request.
> 
> Actually, this approach looks to be a bit too narrow.  You seem to be
> predicating on the idea that the bidirectional will transfer in and out
> of the same area.  For some of the frame in/frame out stuff, we probably
> need the read and write areas for the bidirectional request to be
> separated.

Hmm, our proposal introduces two separate and independent i/o areas.
One used for uni-directional transfers and for bidi data output, the
other is used for bidi data input so we're in agreement.

Benny

 

