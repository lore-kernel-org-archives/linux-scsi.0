From: Douglas Gilbert <dougg@torque.net>
Subject: Re: RFC: SCSI Generic version 4 interface
Date: Tue, 07 Nov 2006 16:09:24 -0500
Message-ID: <4550F604.8040205@torque.net>
References: <454FAD72.6040103@torque.net> <45503A3B.5050107@garzik.org> <20061107153147.GV19471@kernel.dk>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:60348 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1752925AbWKGVJn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Nov 2006 16:09:43 -0500
In-Reply-To: <20061107153147.GV19471@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Tue, Nov 07 2006, Jeff Garzik wrote:
>> Douglas Gilbert wrote:
>>> I was asked to put together a proposal in May this
>>> year for a new SCSI Generic interface structure. This
>>> is the same structure that is used by the block layer
>>> SG_IO ioctl. A few people have asked whether I had forgotten
>>> that I agreed to write the proposal. So here it is. Those
>>> who have seen it have made comments, some of which have
>>> been incorporated.
>>>
>>> Some shortcomings of the sg version 3 interface are:
>>>  - can't handle commands with bidirectional data (either
>>>    can the SCSI subsystem at the moment)
>>>  - if it was a bit more general it could carry other
>>>    request/response protocols (e.g. Task Management
>>>    Functions and SMP in Serial Attached SCSI)
>>>  - no way of associating a task attribute or task tag
>>>    with a SCSI command
>> Why avoid Jens Axboe's bsg?
>>
>> It seems like that is already a good interface for carrying other 
>> req/resp protocols.
> 
> I don't think Doug is avoiding that (if you are Doug, please do explain
> :-), but rather outlining the next generation command format that bsg
> should support for future use.

In the simplest case this is just the next generation
version of the sg_io_hdr structure used by the SG_IO
ioctl interface. It pitches at about the same level as
modern SCSI transports (e.g. FCP, SAS and iSCSI). It
leaves session and addressing issues, with the exception
(arguably) of tags, to others. The "others" could include
the bsg driver or perhaps a transport layer/driver.

Reference:
  SAM-4 version 7 section 5.1 "The Execute command
                               procedure call"
          http://www.t10.org/ftp/t10/drafts/sam4/sam4r07.pdf

Doug Gilbert

