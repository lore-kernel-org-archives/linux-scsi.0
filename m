From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH] drivers/scsi/dpt_i2o: Convert to generic boolean
Date: Tue, 30 Oct 2007 16:02:25 +0100
Message-ID: <47274781.3030606@student.ltu.se>
References: <20071030104806.30936.13253.sendpatchset@thinktank.campus.ltu.se> <20071030145155.GL32359@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:35750 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbXJ3PIx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2007 11:08:53 -0400
In-Reply-To: <20071030145155.GL32359@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Oct 30, 2007 at 11:54:22AM +0100, Richard Knutsson wrote:
>   
>> Convert to use the generic boolean.
>> -	u8 initialized;
>> -	u8 in_use;		/* is the management node open*/
>> +	bool initialized:8;
>> +	bool in_use:8;		/* is the management node open*/
>>     
>
> Are you serious?
>   
Well, yes. It is since it was defined to really be 8 bits before, and 
there is no reason why a boolean would be 8 bits and not 1 or 16.
If it is overly cautious/not needed, then I don't mind removing the ':8'...

Richard Knutsson


