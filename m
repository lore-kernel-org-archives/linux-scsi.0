From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Date: Sat, 15 Aug 2009 22:19:21 -0400
Message-ID: <4A876CA9.20906@rtr.ca>
References: <20090816004705.GA7347@infradead.org> <4A876255.10606@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:49706 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486AbZHPCTR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Aug 2009 22:19:17 -0400
In-Reply-To: <4A876255.10606@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com

Mark Lord wrote:
> Christoph Hellwig wrote:
..
>> Mark, any chance to try it?  Just create an XFS filesystem, age it a
>> bit and then call the attached little trim.c program on the mountmoint
>> (or any file inside the filesystem for that matter)
> ..
> 
> Looking at it now.  Thanks, Christoph!
..

Fails to work on 64-bit kernel w/ 32-bit userspace (no compat ioctl).
Rebuilding with 32-bit kernel now..


