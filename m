From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: sg driver and Fedora Core 2
Date: Sat, 29 May 2004 13:58:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B8CF34.6080901@pobox.com>
References: <40B74725.90403@torque.net>	<20040528172535.GD13961@devserv.devel.redhat.com	>	<1085846125.2101.29.camel@mulgrave>	<20040529155744.GA32621@devserv.devel.	redhat.com>	<1085846840.2103.47.camel@mulgrave>		<20040529162912.GA5922@devserv.devel.redhat.com>	<1085849399.2004.101.camel@mulgrave>  <40B8C81E.3050106@pobox.com> <1085852299.2004.206.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:52436 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264477AbUE2R60
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 13:58:26 -0400
In-Reply-To: <1085852299.2004.206.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Cox <alan@redhat.com>, Douglas Gilbert <dougg@torque.net>, Arjan van de Ven <arjanv@redhat.com>, Jens Axboe <axboe@suse.de>

James Bottomley wrote:
> On Sat, 2004-05-29 at 12:27, Jeff Garzik wrote:
> 
>>Really what needs to happen is a generic userland tap attaches to a 
>>chrdev, issues an ioctl(2) to attach to a request_queue, and then does 
>>read(2)/write(2)/mmap(2) to communicate with the request_queue.
>>
>>:)
>>
>>Call it /dev/bsg, or somesuch.
> 
> 
> Well, this touches on something else I'm thinking about: lazy
> attachment.  In multi thousand disc environments, you don't want us
> wasting resources allocating a queue and reading a partition table for
> all of them; you really only want to do that for the devices you're
> actually going to use.  Once we have this, I think dual attachment will
> be a dead issue.


Regardless of lazy attachment, request_queues need to support multiple 
simultaneous producers of struct request's.

	Jeff


