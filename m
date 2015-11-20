From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: kernel BUG at drivers/scsi/scsi_lib.c:1096!
Date: Fri, 20 Nov 2015 23:10:48 +1100
Message-ID: <1448021448.14769.7.camel@ellerman.id.au>
References: <1447838334.1564.2.camel@ellerman.id.au>
	 <1447855399.3974.24.camel@redhat.com>
	 <1447894964.15206.0.camel@ellerman.id.au>
	 <20151119082325.GA11419@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:44036 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757831AbbKTMKu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2015 07:10:50 -0500
In-Reply-To: <20151119082325.GA11419@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mark Salter <msalter@redhat.com>, "James E. J. Bottomley" <JBottomley@odin.com>, brking <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-block@vger.kernel.org, Laurent Dufour <ldufour@linux.vnet.ibm.com>

On Thu, 2015-11-19 at 00:23 -0800, Christoph Hellwig wrote:

> It's pretty much guaranteed a block layer bug, most likely in the
> merge bios to request infrastucture where we don't obey the merging
> limits properly.
> 
> Does either of you have a known good and first known bad kernel?

Not me, I've only hit it one or two times. All I can say is I have hit it in
4.4-rc1.

Laurent, can you narrow it down at all?

cheers

