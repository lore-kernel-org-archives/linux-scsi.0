From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 3/14] lpfc 8.3.0 :  Add kernel-doc headers to lpfc_scsi.c
Date: Fri, 05 Dec 2008 09:25:20 -0800
Message-ID: <49396400.7020508@oracle.com>
References: <1228448342.19053.39.camel@ogier> <4939577F.1030804@oracle.com> <493962D5.9010103@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet13.oracle.com ([148.87.113.125]:59271 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbYLERZ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2008 12:25:29 -0500
In-Reply-To: <493962D5.9010103@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@emulex.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James Smart wrote:
> Randy,
> 
> Thanks. Looks like we have this mistake in quite a few places.
> 
> Any issue if we proceed with this patch set as is, and I'll turn around
> and issue another set that addresses the kernel-doc style explicitly ?

That's OK with me if it's done soon.


> -- james s
> 
> 
> Randy Dunlap wrote:
>> James Smart wrote:
>>> lpfc 8.3.0 : Add kernel-doc function headers to lpfc_scsi.c
>>>
>>> Add kernel-doc function headers to lpfc_scsi.c
>>>
>>
>> Hi James,
>>
>> kernel-doc is a small language, with a small bit of syntax. It's
>> documented
>> in Documentation/kernel-doc-nano-HOWTO.txt.
>>
>> I say this because all of the first lines (function name/short
>> description)
>> use : instead of - to separate the name from the description.
>> Please fix those.
>>
>> Also, the function name/short description can only be one line, so
>> either make
>> it > 80 characters if needed, or use this format:
>>
>> /**
>>  * lpfc_snaz - do some snazzy stuff
>>  * @hba: the target hba
>>  *
>>  * lpfc_snaz does some cool stuff and some hot stuff, such as-
>>  * - system snapshot to hba memory
>>  * - system check for infections and intrusions
>>  * - starts the coffee maker
>>  **/
