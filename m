From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] include/scsi/scsi.h replace u8 in 2.5.69
Date: Wed, 14 May 2003 09:05:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC23F04.8000404@pobox.com>
References: <3EC1E4AF.6040404@torque.net> <20030514090218.A7371@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:17615 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262069AbTENMwc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 May 2003 08:52:32 -0400
In-Reply-To: <20030514090218.A7371@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, May 14, 2003 at 04:39:43PM +1000, Douglas Gilbert wrote:
> 
>>Here is a simple patch to replace the single occurrence
>>of "u8" with "u_char" in include/scsi/scsi.h .
> 
> 
> That's wrong.  No userland should include kernwel headers.
> (and u_char is a non-standard type, too).


Agreed.  And like Douglas guessed, uint8_t is preferred over u_char :)

	Jeff



