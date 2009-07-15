From: rohan a <info1686@gmail.com>
Subject: Re: SCSI command (SP-OUT) failing on SLES 9 32-bit
Date: Wed, 15 Jul 2009 20:33:27 +0530
Message-ID: <7a7c22420907150803v4f4ae9dn9eff41b5d5a7edf6@mail.gmail.com>
References: <7a7c22420907142137o4253dfb5gcd72176cd6a38beb@mail.gmail.com>
	 <7a7c22420907142326t3b8d4f5fqaf3813cb456186ec@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:46606 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbZGOPD2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2009 11:03:28 -0400
In-Reply-To: <7a7c22420907142326t3b8d4f5fqaf3813cb456186ec@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Hi guys,

Any suggestions...please help


On Wed, Jul 15, 2009 at 11:56 AM, rohan a<info1686@gmail.com> wrote:
> I do not want to move to the SG3 driver as of now since all devices
> are working on all Linux platforms using the deprectaed SG driver.
>
>
>
> On 7/15/09, rohan a <info1686@gmail.com> wrote:
>> Hello,
>> =A0 =A0 =A0 =A0The SCSI command for LTO-4 drive based encryption (SP=
OUT
>> opcode =3D 0xB5) is failing on SLES 9 32-bit only and not on SLES 9 =
(64-
>> bit), SLES 10,11 or RHEL 4/5
>>
>> Any idea why this is happening?
>>
>> Error returned is : Invalid field in CDB
>>
>> I am using ioctl() with the deprecated request SCSI_IOCTL_SEND_COMMA=
ND
>> and not the SG3 driver.
>> However, only the SPOUT command is failing and none of the other SCS=
I
>> commands.
>> For ex: even the SPIN command (to obtain encryption status and
>> capabilities) works.
>>
>> I even updated to SP4.
>>
>> Any suggestions here?
>>
>> Thanks
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
