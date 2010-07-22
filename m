From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] md: bitwise operations might not fit in a "bool"
Date: Thu, 22 Jul 2010 15:20:53 +0300
Message-ID: <4C4837A5.6040209@panasas.com>
References: <4C47ED7B.1050709@gmail.com>	<20100722173716.66264bef@notabene>	<4C481FD5.4070509@gmail.com>	<4C482F35.6000004@panasas.com> <20100722215555.7ab2b1ee@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:38414 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751761Ab0GVMVE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2010 08:21:04 -0400
In-Reply-To: <20100722215555.7ab2b1ee@notabene>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Jiri Slaby <jirislaby@gmail.com>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, hch@lst.de, jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org

On 07/22/2010 02:55 PM, Neil Brown wrote:
> On Thu, 22 Jul 2010 14:44:53 +0300
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>>
>> when taking a resolute of a bit-wise AND as true false. Better / faster
>> to make it a boolean operation.
>>
>> This fixes a bug and a crash because the flags field did not fit into
>> the bool operands.
> 
> No, that won't work.
> Read the rest of the code and see where 'do_sync' and 'do_barriers' are used.
> 
> NeilBrown
> 

You are right! (I didn't look)

the use of "bool" was wrong from the get go. it was never a bool operation.
What was the guy thinking? What is that do_XXX name? that name should change
as well. Perhaps flg_sync, flg_barriers.

Boaz
