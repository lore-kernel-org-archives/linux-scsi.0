From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 0/2] struct scsi_lun preparation
Date: Mon, 11 Sep 2006 17:41:51 -0400
Message-ID: <4505D81F.5020300@garzik.org>
References: <664A4EBB07F29743873A87CF62C26D70307646@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:41665 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751022AbWIKVl4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Sep 2006 17:41:56 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70307646@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Moore, Eric wrote:
> On Monday, September 11, 2006 1:56 PM, Jeff Garzik wrote: 
> 
>>> A pretty print for the current u32 would be very useful though for
>>> transports dealing with non single level luns (or address 
>> methods other
>>> than zero).
>> A better subject line would have been "HCIL isolation" I suppose.  I 
>> would like to see increased usage of the accessors already present in 
>> include/scsi/scsi_device.h, which would ease the transition from 
>> hardcoded HCIL struct members to a more flexible addressing method.
>>
>> Though, FWIW, for LUNs I would certainly like to see u64 rather than 
>> u32.....
>>
> 
> shouldn't luns be defined as: 
> 
> u8 lun[8] instead of u64?  

Please, not that argument again :)

It's purely semantics, the same storage is used, and only very rarely 
are the contents actually examined in either case.

	Jeff



