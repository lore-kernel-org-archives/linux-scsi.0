From: Brian King <brking@us.ibm.com>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Tue, 20 Jan 2004 16:37:12 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <400DAD98.2040902@us.ibm.com>
References: <40085EDA.4010802@us.ibm.com> <20040119183400.A4182@infradead.org> <400C3E70.9040702@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:40320 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265800AbUATWhj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 17:37:39 -0500
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

>> +/**
>> + * ipr_find_ses_entry - Find matching SES in SES table
>> + * @res:    resource entry struct of SES
>> + * + * Return value:
>> + *     pointer to SES table entry / NULL on failure
>> + **/
>>
>> This is an extreme layering violation.  Any SES handling belongs into an
>> upper level scsi driver (or userspace via sg)
> 
> 
> I'm not actually talking to the SES, I'm only looking at the adapter's 
> device configuration table. What I am trying to accomplish here is I am 
> looking at each SCSI bus and trying to determine the max scsi speed that 
> is safe to run on them. There are certain older backplanes that do not 
> run reliably at faster speeds. Hence, the SES table.

Did my explanation help, or would you still like this code removed? I don't
have a huge problem moving it into userspace, the only downside is that
I will only be able to run at 80MB/sec until the configuration tool runs.



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

