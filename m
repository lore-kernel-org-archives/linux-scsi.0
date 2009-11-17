From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 9/9] osd_protocol.h: Add missing #include
Date: Tue, 17 Nov 2009 09:54:17 +0200
Message-ID: <4B0256A9.5090406@panasas.com>
References: <4B019BEC.3080909@panasas.com>	 <1258397365-356-1-git-send-email-bharrosh@panasas.com>	 <20091116185741.GH8113@deprecation.cyrius.com>	 <4B01A174.8000005@panasas.com> <1258401694.2517.245.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:59004 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751588AbZKQHyO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2009 02:54:14 -0500
In-Reply-To: <1258401694.2517.245.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Martin Michlmayr <tbm@cyrius.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

On 11/16/2009 10:01 PM, James Bottomley wrote:
> On Mon, 2009-11-16 at 21:01 +0200, Boaz Harrosh wrote:
>> On 11/16/2009 08:57 PM, Martin Michlmayr wrote:
>>> * Boaz Harrosh <bharrosh@panasas.com> [2009-11-16 20:49]:
>>>> From: Martin Michlmayr <tbm@cyrius.com>
>>>>
>>>> include/scsi/osd_protocol.h uses ALIGN() without an #include
>>>> <linux/kernel.h>, leading to:
>>>> | include/scsi/osd_protocol.h:362: error: implicit declaration of function 'ALIGN'
>>>
>>> Note that this patch also has to go into 2.6.32, where OSD currently
>>> builds to build (at least on ARM).
>>
>> OK in that case we need to CC: stable@kernel.org, inside the patch
>>
>> James could you add it to the patch? Should I re-post?

Sorry, yes you are right.

> 
> I can add it.
> 

Thanks
> James
> 
> 

Boaz
