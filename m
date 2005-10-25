From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 0/2] libata: support SATA devices on SAS HBAs
Date: Tue, 25 Oct 2005 08:53:18 -0500
Message-ID: <435E38CE.9000000@us.ibm.com>
References: <4341A91A.3020000@us.ibm.com> <434251E0.9060000@pobox.com>	 <58cb370e0510040322q1cb7a13bjfc6c7875140d20a9@mail.gmail.com> <58cb370e0510041356h780e7a5aifda0c232f677471e@mail.gmail.com> <43443E99.4090008@pobox.com> <435D5D83.1060201@us.ibm.com> <435E2C25.10009@adaptec.com> <435E357D.1020800@us.ibm.com> <435E35D1.4070907@adaptec.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43929 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932147AbVJYNxV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Oct 2005 09:53:21 -0400
In-Reply-To: <435E35D1.4070907@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Luben Tuikov wrote:
>>>Hey Brian,
>>>
>>>That's admireable effort.  Is there a git tree I can pull from which has
>>>these patches?  (I don't mind using the patches themselves as well.)
>>>
>>>I'll take a look indepth and comment further.
>>>
>>>Thanks,
>>>	Luben
>>
>>
>>Hey Luben,
>>
>>I don't have a git tree setup, just the three patches. 
> 
> 
> I assume you've tested them already on the SAS Transport Layer?

Unfortunately, no. My primary goal is to have an API I can use
in the ipr LLDD, which is a RAID adapter which will talk 
SPI, SAS, and SATA. I am still trying to get the patches tested
in my environment, but since there has been some discussion on the
list about others needing the same function I figured I would share
what I have with a wider audience.

Thanks,

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
