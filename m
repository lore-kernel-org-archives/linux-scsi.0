From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: sleeping in scsi EH
Date: Fri, 27 May 2005 04:37:29 -0400
Message-ID: <4296DC49.5020907@pobox.com>
References: <42968560.7020608@pobox.com> <20050527070954.GA27256@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:4830 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S262131AbVE0Ihc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 04:37:32 -0400
In-Reply-To: <20050527070954.GA27256@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Christoph Hellwig wrote:
> You can sleep in them.  You must however release the host lock and enable
> irqs first and reverse that before returning.  The error handlers don't
> need the host lock, but we're stuck with the unfortunate calling convention
> for now.

Why are we stuck with this calling convention, when everyone who cares 
circumvents it?

	Jeff


