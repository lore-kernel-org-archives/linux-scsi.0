From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: [TRIVIAL] warning cleanup for drivers_scsi_qla1280.c
Date: 23 Jun 2003 04:51:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m38yrtnpmy.fsf@trained-monkey.org>
References: <20030623070135.AF6A72C292@lists.samba.org>
	<20030623094559.A3460@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from trained-monkey.org ([209.217.122.11]:65041 "EHLO
	trained-monkey.org") by vger.kernel.org with ESMTP id S265102AbTFWIhC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2003 04:37:02 -0400
In-Reply-To: <20030623094559.A3460@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Rusty Trivial Russell <rusty@rustcorp.com.au>, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> On Mon, Jun 23, 2003 at 04:47:25PM +1000, Rusty Trivial
Christoph> Russell wrote:
>> [ This function is unused if kernel > 2.1.95, so put #ifdef around
>> whole thing to avoid warning. --RR ]

Christoph> I'd say kill it completly.  qlogic has stopped maintaining
Christoph> the driver and there's other places in the driver that
Christoph> won't work anymore with 2.0.

Hi Christoph and Rusty

The current qla1280 codebase found in 2.4 is utter rubbish. I have a
major cleanup of it almost ready in which I already killed all the
< 2.4.x support.

I hope to get this new version out shortly, so this patch is probably
obsolete.

Cheers,
Jes
