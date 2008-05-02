From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 2.6.25.1] Add scsi_execute_async_fifo()
Date: Fri, 02 May 2008 22:21:08 +0400
Message-ID: <481B5B94.8050407@vlnb.net>
References: <200805021638.42972.bart.vanassche@gmail.com> <20080502153306.GB7376@infradead.org> <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com> <20080502155525.GA16353@infradead.org> <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com> <20080502161629.GF14976@parisc-linux.org> <e2e108260805020923wc7a9e0bl539eaa386d8410bb@mail.gmail.com> <20080502164905.GH14976@parisc-linux.org> <e2e108260805020957k2390b151t7fe6beacc9fe8b34@mail.gmail.com> <20080502170244.GI14976@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:52972 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763115AbYEBSUl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 14:20:41 -0400
In-Reply-To: <20080502170244.GI14976@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <tomof@acm.org>

Matthew Wilcox wrote:
> On Fri, May 02, 2008 at 06:57:10PM +0200, Bart Van Assche wrote:
>> Thanks for looking this up. Would it be an acceptable approach if the
>> SCST code is modified such that it calls the code inside
>> drivers/scsi/scsi_tgt_lib.c whenever this is appropriate ?
> 
> You need to talk to Mike and Tomo.
> 
>>From my point of view, the most important bit is the target layer <->
> driver API.  ie the transfer_response() method in the host template.
> I'm sure other people have their own preferences though.

SCST can't use anything from STGT or other SCSI targets support 
functionality of the kernel. But it can integrate inside something from 
transport attributes. See my e-mail with subject "SCSI target subsystem" 
why.

Vlad


