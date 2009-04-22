From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH v2] fix sign extension with 1.5TB usb-storage LBD=y
Date: Wed, 22 Apr 2009 14:27:12 +0300
Message-ID: <49EEFF10.3050306@panasas.com>
References: <1240347174.10627.20.camel@nimitz> <20090421211858.GA1926@parisc-linux.org> <1240351210.10627.30.camel@nimitz> <49EEC82B.5040603@panasas.com> <20090422110921.GE1926@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:30164 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751409AbZDVL1k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 07:27:40 -0400
In-Reply-To: <20090422110921.GE1926@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, mdharm-usb@one-eyed-alien.net, linux-usb <linux-usb@vger.kernel.org>, usb-storage@lists.one-eyed-alien.net, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, viro <viro@zeniv.linux.org.uk>

On 04/22/2009 02:09 PM, Matthew Wilcox wrote:
> On Wed, Apr 22, 2009 at 10:32:59AM +0300, Boaz Harrosh wrote:
>> These are actually aligned access it might be worth sacrificing a cast
>> to be32/64 for sake of speed.
> 
> "for sake of speed"?  How often do you think we ask a device how large
> it is?  

OK, that was the wrong choice of words, on my part. I meant for sake of
"nobleness". I calculated as a programmer that these are aligned do I make
the extra effort of stating that in code, or I get lazy because it does
not matter?

> How much overhead do you think is incurred by the unaligned code
> if the data happens to be aligned?
> 

Well for BE systems we are already order of magnitude faster by just
using the accessors, so I guess we are already well in the "plus" ;)

This is such a small matter, sorry to bother you about it.
Just that it's a programming style I'm constantly debating with myself,
feel free to ignore it.

The patch looks very good to me as it is.

Thanks
Boaz
