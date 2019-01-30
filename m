From: Joao Pinto <joao.pinto@synopsys.com>
Subject: Re: [PATCH for-next] scsi: ufs: Update dwc driver maintainer to Pedro
 Sousa
Date: Wed, 30 Jan 2019 19:15:56 +0000
Message-ID: <f0ff398e-cc13-d70d-0488-d35faa126a5a@synopsys.com>
References: <812e9e1426555808ad1bd5fbfda320c6684abc81.1548869844.git.jpinto@synopsys.com>
 <1548870848.213038.3.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548870848.213038.3.camel@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Joao Pinto <joao.pinto@synopsys.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: pedrom.sousa@synopsys.com, marc.w.gonzalez@free.fr, Alex.Lemberg@wdc.com
List-Id: linux-scsi@vger.kernel.org

Hello Bart,

First of all thanks for the feedback.

On 1/30/2019 5:54 PM, Bart Van Assche wrote:
> On Wed, 2019-01-30 at 18:48 +0100, Joao Pinto wrote:
>> Currently I am managing the Synopsys drivers & tools team (full-time) and
>> so I am passing the DWC UFS driver maintenance to Pedro Sousa.
>>
>> Signed-off-by: Joao Pinto <jpinto@synopsys.com>
>> Cc: Pedro Sousa <pedrom.sousa@synopsys.com>
>> Cc: Marc Gonzalez <marc.w.gonzalez@free.fr>
>> Cc: Alex Lemberg <Alex.Lemberg@wdc.com>
>> ---
>>  MAINTAINERS | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 70c93b1..458a2a2 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -15673,7 +15673,7 @@ F:	Documentation/scsi/ufs.txt
>>  F:	drivers/scsi/ufs/
>>  
>>  UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER DWC HOOKS
>> -M:	Joao Pinto <jpinto@synopsys.com>
>> +M:	Pedro Sousa <pedrom.sousa@synopsys.com>
>>  L:	linux-scsi@vger.kernel.org
>>  S:	Supported
>>  F:	drivers/scsi/ufs/*dwc*
> Shouldn't people have proven to be willing to stick around before being
> added as a kernel maintainer? Additionally, what is the experience level of
> Pedro with kernel development? All I know is the following:

Pedro Sousa is my team member and has been working in Unipro/UFS Synopsys
drivers for almost 2 years.

His work has been mainly internal, and now our goal is to start using the
mainline DWC UFS driver I submitted 2 years ago in our regular activities,
update and maintain it effectively as we are doing in other titles.

Currently I am Pedro' manager, and in my opinion he has the right experience for
this step and that is why I am suggesting to transfer Synopsys driver
maintenance from me to him.

>
> $ git log --author "Pedro Sousa" | wc -l
> 0
> $ git log | grep -c "Pedro Sousa"
> 0
>
> Are you aware that people who are not mentioned in the MAINTAINERS file are
> allowed to review kernel patches?

Yes, I am aware and Pedro is perfectly capable of doing that, and for that
reason I am suggesting him as the right person to maintain Synopsys UFS driver.

>
> Thanks,
>
> Bart.
>
Thanks,

Joao
