From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [BUG raid1] kernel BUG at drivers/scsi/scsi_lib.c:1113
Date: Wed, 18 Aug 2010 13:42:38 +0200
Message-ID: <4C6BC72E.6040607@gmail.com>
References: <20100817220917.GA5268@Krystal> <4C6B097E.7060505@gmail.com> <20100817223145.GC4641@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41434 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab0HRLmn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2010 07:42:43 -0400
In-Reply-To: <20100817223145.GC4641@Krystal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, hch@lst.de, jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org

On 08/18/2010 12:31 AM, Mathieu Desnoyers wrote:
> * Jiri Slaby (jirislaby@gmail.com) wrote:
>> On 08/18/2010 12:09 AM, Mathieu Desnoyers wrote:
>>> This is with these changes applied:
>>
>> Hi, these are very wrong. Please use ones from:
>> http://lkml.org/lkml/2010/8/12/98
> 
> Yep, my system boot fine now.
> 
> Any plans to fast-track these fixes to mainline ?

Neil sent a pull request for the raid fixup earlier today.

James and Jens, could you take the two remaining (SCSI and BLOCK)?

thanks,
-- 
js
