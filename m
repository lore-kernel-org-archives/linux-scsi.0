From: Suman Tripathi <stripathi@apm.com>
Subject: Re: [PATCH 2/2] ahci_xgene: Implement the workaround to support PMP
 enumeration and discovery for APM X-Gene SoC AHCI SATA Host Controller driver.
Date: Mon, 5 Jan 2015 19:33:06 +0530
Message-ID: <CAOHikRBedNy=CrrHA+7UYQJpL3t1BhU0VFixz80bPeSE28iHGw@mail.gmail.com>
References: <1420453305-15986-1-git-send-email-stripathi@apm.com>
	<1420453305-15986-3-git-send-email-stripathi@apm.com>
	<20150105133005.GB15833@htj.dyndns.org>
	<20150105135950.GE15833@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20150105135950.GE15833@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Mark Langsdorf <mlangsdo@redhat.com>, Jon Masters <jcm@redhat.com>, patches@apm.com
List-Id: linux-scsi@vger.kernel.org

Reverted due to conflicts with the endian fix patches.  Please rebase
these two on top of them.

Will do that .. I should have wait for the endian patch getting
accepted. Sorry for that.

On Mon, Jan 5, 2015 at 7:29 PM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Jan 05, 2015 at 08:30:05AM -0500, Tejun Heo wrote:
>> On Mon, Jan 05, 2015 at 03:51:45PM +0530, Suman Tripathi wrote:
>> > Due to H/W errata, the controller is unable to save the PMP
>> > field fetched from command header before sending the H2D FIS.
>> > When the device returns the PMP port field in the D2H FIS, there is
>> > a mismatch and results in command completion failure. The workaround
>> > is to write the pmp value to PxFBS.DEV field before issuing any command
>> > to PMP.
>> >
>> > Signed-off-by: Suman Tripathi <stripathi@apm.com>
>>
>> Applied 1-2 to libata/for-3.20.
>
> Reverted due to conflicts with the endian fix patches.  Please rebase
> these two on top of them.
>
> Thanks.
>
> --
> tejun



-- 
Thanks,
with regards,
Suman Tripathi
CONFIDENTIALITY NOTICE: This e-mail message, including any attachments, 
is for the sole use of the intended recipient(s) and contains information
that is confidential and proprietary to Applied Micro Circuits Corporation or its subsidiaries. 
It is to be used solely for the purpose of furthering the parties' business relationship. 
All unauthorized review, use, disclosure or distribution is prohibited. 
If you are not the intended recipient, please contact the sender by reply e-mail 
and destroy all copies of the original message.

