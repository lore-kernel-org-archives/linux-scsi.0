From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/2] be2iscsi: check ip buffer before copying
Date: Mon, 29 Sep 2014 14:08:13 -0500
Message-ID: <5429AE1D.1040600@cs.wisc.edu>
References: <1412016942-4759-1-git-send-email-michaelc@cs.wisc.edu>	 <1412016942-4759-2-git-send-email-michaelc@cs.wisc.edu> <1412017610.6067.18.camel@jarvis.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42845 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187AbaI2TIV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 15:08:21 -0400
In-Reply-To: <1412017610.6067.18.camel@jarvis.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On 09/29/2014 02:06 PM, James Bottomley wrote:
> On Mon, 2014-09-29 at 13:55 -0500, michaelc@cs.wisc.edu wrote:
>> From: Mike Christie <michaelc@cs.wisc.edu>
>>
>> Dan Carpenter found a issue where be2iscsi would copy the ip
>> from userspace to the driver buffer before checking the len
>> of the data being copied:
>> http://marc.info/?l=linux-scsi&m=140982651504251&w=2
>>
>> This patch just has us only copy what we the driver buffer
>> can support.
>>
>> Tested-by: John Soni Jose <sony.john-n@emulex.com>
>> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> 
> This looks to be a long standing and potentially exploitable bug ...
> does it need a cc to stable?
> 

Yeah, sorry. Forgot to cc. Do you need me to resend with them ccd?

