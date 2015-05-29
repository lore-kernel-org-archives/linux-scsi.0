From: James Smart <james.smart@avagotech.com>
Subject: Re: [PATCH v2 12/15] lpfc: Fix rport leak.
Date: Fri, 29 May 2015 10:08:09 -0400
Message-ID: <556872C9.20606@avagotech.com>
References: <555e1c10.+P+E84TfJG4E7Wsc%james.smart@avagotech.com>	<20150524135636.00000f81@localhost>	<5564755B.5030302@avagotech.com> <20150527233200.00006352@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:36339 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbbE2OIM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2015 10:08:12 -0400
Received: by qgf2 with SMTP id 2so29552251qgf.3
        for <linux-scsi@vger.kernel.org>; Fri, 29 May 2015 07:08:12 -0700 (PDT)
In-Reply-To: <20150527233200.00006352@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: linux-scsi@vger.kernel.org

That's good to know.  We have a fair amount of existing strings that are 
split, so I don't want to retrofit those. But, on future submits, we'll 
keep the string on a single line.

Thanks

-- james


On 5/27/2015 5:32 PM, Sebastian Herbszt wrote:
> James Smart wrote:
>> Sebastian,
>>
>> Re: more than 1 space between a type declaration and a variable name - I
>> do not believe that's a hard requirement. It fully passes checkpatch.
>> Yes, consistent style use (aligning all variable names at same offset,
>> or always 1) would be good - but code has been there so long with
>> althernate styles it doesn't really matter at this point.  I did clean
>> up those in your last review as I needed to do a mod for the LS_RJT
>> behavior. But... this seems like a nit.   I did promise Christoph that I
>> would pick a good point and retrofit the sources for all sparse warnings
>> - and still owe him.
>>
>> Re: Checkpatch and string splitting. I understand we aren't passing
>> checkpatch for that rule, but joining them would have checkpatch
>> flagging us for beyond 80 character lines.
> checkpatch seems to just follow what's mentioned in CodingStyle "Chapter 2:
> Breaking long lines and strings":
>
> "However, never break user-visible strings such as printk messages, because
> that breaks the ability to grep for them."
>
> The tool is actually smart enough to not flag such lines as LONG_LINE.
>
>> I'd much rather have the
>> splits and keep the indenting for readability. We have also had this
>> error quite a bit in the past and believe we have been grandfathered as
>> there's a lot of this already.
>>
>> James B - any comments on the above ?
>>
>> -- james s
> Sebastian

