From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: LUN resizing
Date: 28 Nov 2003 10:18:51 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070036333.1907.14.camel@mulgrave>
References: <1069708054.26088.127.camel@lt-sv>
	<1069774983.2061.28.camel@mulgrave> <1069776713.1787.36.camel@mulgrave>
	<1069839911.26091.443.camel@lt-sv>  <20031126094804.A2717@infradead.org>
	<1069965713.886.38.camel@lt-sv>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:61703 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262581AbTK1QT7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2003 11:19:59 -0500
In-Reply-To: <1069965713.886.38.camel@lt-sv>
List-Id: linux-scsi@vger.kernel.org
To: Stefan Voelkel <Stefan.Voelkel@millenux.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2003-11-28 at 04:08, Stefan Voelkel wrote:
> True, let's forget about the partitions: mount /dev/sda /home. 

OK, Let's try again in simpler terms.

The problem you are trying to solve has three components:

1. Filesystem resize
2. parition resize
3. SCSI device resize

1 and 3 are solved (for a subset of fs).  A solution to 2 is to use the
Linux device mapper (a mini volume manager) to replace the use of
gendisk partitions.  Then your entire stack constructed this way will be
resizable.

The place to begin finding out about DM is the development lists:

dm-devel@sistina.com

With a list archive at:

http://lists.sistina.com/pipermail/dm-devel/

James


