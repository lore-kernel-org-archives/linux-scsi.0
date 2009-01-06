From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH 1/5] mpt fusion: Update MPI Headers to version 01.05.19
Date: Tue, 6 Jan 2009 09:48:06 -0800
Message-ID: <da824cf30901060948n80a46cbl2b2fbce36bdc1aa7@mail.gmail.com>
References: <20090106092618.GC13033@lsi.com>
	 <1231255256.7090.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:13106 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbZAFRsM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 12:48:12 -0500
Received: from wpaz29.hot.corp.google.com (wpaz29.hot.corp.google.com [172.24.198.93])
	by smtp-out.google.com with ESMTP id n06HmAwe022301
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jan 2009 09:48:11 -0800
Received: from fk-out-0910.google.com (fkx26.prod.google.com [10.94.24.26])
	by wpaz29.hot.corp.google.com with ESMTP id n06Hm7ft026942
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jan 2009 09:48:07 -0800
Received: by fk-out-0910.google.com with SMTP id 26so4766501fkx.4
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2009 09:48:07 -0800 (PST)
In-Reply-To: <1231255256.7090.7.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Kashyap, Desai" <kashyap.desai@lsi.com>, linux-scsi@vger.kernel.org, eric.moore@lsi.com, sathyap@lsi.com

On Tue, Jan 6, 2009 at 7:20 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2009-01-06 at 14:56 +0530, Kashyap, Desai wrote:
>> This Patch is submitted to increment the MPI headers used by LSI MPT fusion
>> drivers to the latest version 01.05.19.
>
> You mean 01.05.16?  That's what all the headers say:

-#define MPI_HEADER_VERSION_UNIT             (0x10)
+#define MPI_HEADER_VERSION_UNIT             (0x13)



>
>> Year is changed in CopyRight.
>> ---
>>
>> Signed-off-by: Kashyap Desai <kadesai@lsi.com>
>> ---
>> diff --git a/drivers/message/fusion/lsi/mpi.h b/drivers/message/fusion/lsi/mpi.h
>> index 10b6ef7..11c0f46 100644
>> --- a/drivers/message/fusion/lsi/mpi.h
>> +++ b/drivers/message/fusion/lsi/mpi.h
>> @@ -6,7 +6,7 @@
>>   *          Title:  MPI Message independent structures and definitions
>>   *  Creation Date:  July 27, 2000
>>   *
>> - *    mpi.h Version:  01.05.13
>> + *    mpi.h Version:  01.05.16
>                         ^^^^^^^^

The code and the comments obviously don't agree:
-#define MPI_HEADER_VERSION_UNIT             (0x10)
+#define MPI_HEADER_VERSION_UNIT             (0x13)

Kashyap,

James was implying you need to rework/resubmit the patch
so the code and comments agree.

grant
