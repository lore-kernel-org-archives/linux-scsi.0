From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [bk patches] move scsi headers
Date: Tue, 27 May 2003 01:19:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3ED2F568.7060501@pobox.com>
References: <20030527034239.GA16376@gtf.org> <20030527061444.A1905@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:54217 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263452AbTE0FGe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2003 01:06:34 -0400
In-Reply-To: <20030527061444.A1905@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, May 26, 2003 at 11:42:39PM -0400, Jeff Garzik wrote:
> 
>>James, please do a
>>
>>	bk pull bk://kernel.bkbits.net/jgarzik/scsi-misc-2.5
> 
> 
> Also I already told you that the header organisation is crap.  include/scsi
> exists for a reason, the scsi.h/host.h split is broken and scsi_obsolete.h
> should go away not moved around.
> 
> If you want to do something useful you could start removing scsi_obsolete.h,
> make the scsi core and scsi.h/hosts.h clean of the obsolete typedefs first.


This is too ambitious this close to 2.6-pre, and there is also 
disagreement about use of include/scsi.  I took the minimal patch.

As we are very close to 2.6-pre, your suggestions may even want waiting 
until 2.7.  I'll leave it up to James...

Consider this a first step.  The world does not change in a day :)

	Jeff



