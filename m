From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Subject: Re: kernel BUG at drivers/scsi/scsi_lib.c:1096!
Date: Fri, 20 Nov 2015 13:56:47 +0100
Message-ID: <564F188F.4080502@linux.vnet.ibm.com>
References: <1447838334.1564.2.camel@ellerman.id.au>
 <1447855399.3974.24.camel@redhat.com>
 <1447894964.15206.0.camel@ellerman.id.au>
 <20151119082325.GA11419@infradead.org>
 <1448021448.14769.7.camel@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:53992 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162299AbbKTM44 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2015 07:56:56 -0500
Received: from localhost
	by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ldufour@linux.vnet.ibm.com>;
	Fri, 20 Nov 2015 12:56:53 -0000
In-Reply-To: <1448021448.14769.7.camel@ellerman.id.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>, Christoph Hellwig <hch@infradead.org>
Cc: Mark Salter <msalter@redhat.com>, "James E. J. Bottomley" <JBottomley@odin.com>, brking <brking@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-block@vger.kernel.org

On 20/11/2015 13:10, Michael Ellerman wrote:
> On Thu, 2015-11-19 at 00:23 -0800, Christoph Hellwig wrote:
> 
>> It's pretty much guaranteed a block layer bug, most likely in the
>> merge bios to request infrastucture where we don't obey the merging
>> limits properly.
>>
>> Does either of you have a known good and first known bad kernel?
> 
> Not me, I've only hit it one or two times. All I can say is I have hit it in
> 4.4-rc1.
> 
> Laurent, can you narrow it down at all?

I'm trying bisect it but it's very time consuming, and I think I missed
some bad kernel because I didn't let enough time to the system to panic.

But I'm still on...

Cheers

