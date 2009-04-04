From: Jing Huang <jhuang007@gmail.com>
Subject: Re: [PATCH 4/5] bfa: Brocade BFA FC SCSI driver (makefile)
Date: Sat, 4 Apr 2009 20:41:36 +0800
Message-ID: <b674f4c50904040541l523c489eh3556819a022c1ed7@mail.gmail.com>
References: <200904020335.n323ZJVh004287@blc-10-2.brocade.com>
	 <1238679361.3383.4.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:60655 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbZDDMli convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Apr 2009 08:41:38 -0400
In-Reply-To: <1238679361.3383.4.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Krishna Gudipati <kgudipat@brocade.com>, huangj@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, nkattang@brocade.com, rvadivel@brocade.com, vravindr@brocade.com

On Thu, Apr 2, 2009 at 9:36 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Wed, 2009-04-01 at 20:35 -0700, Krishna Gudipati wrote:
>> From: Krishna Chaitanya Gudipati <kgudipat@brocade.com>
>>
>> This patch contains Makefile and Kconfig file for scsi and bfa.Fixed
>> the code review comments from previous submission.
>>
>> Signed-off-by: Krishna Chaitanya Gudipati <kgudipat@brocade.com>
>> ---
>> =A0Kconfig =A0 =A0 =A0| =A0 =A09 +++++++++
>> =A0Makefile =A0 =A0 | =A0 =A01 +
>> =A0bfa/Makefile | =A0 27 +++++++++++++++++++++++++++
>> =A03 files changed, 37 insertions(+)
>>
>> diff -urpN orig/drivers/scsi/Kconfig patch/drivers/scsi/Kconfig
>> --- orig/drivers/scsi/Kconfig 2009-04-01 20:08:49.271161000 -0700
>> +++ patch/drivers/scsi/Kconfig =A0 =A0 =A0 =A02009-04-01 20:08:44.00=
3822000 -0700
>> @@ -1797,6 +1797,15 @@ config SCSI_SRP
>> =A0 =A0 =A0 =A0 To compile this driver as a module, choose M here: t=
he
>> =A0 =A0 =A0 =A0 module will be called libsrp.
>>
>> +config SCSI_BFA_FC
>> + =A0 =A0 tristate "Brocade BFA Fibre Channel Support"
>> + =A0 =A0 depends on PCI && SCSI
>> + =A0 =A0 help
>> + =A0 =A0 =A0 This bfa driver supports all Brocade PCIe Fibre Channe=
l host adapters.
>> +
>> + =A0 =A0 =A0 To compile this driver as a module, choose M here. The=
 module will
>> + =A0 =A0 =A0 be called bfa.
>> +
>
> You're still not using the FC transport class to export common sysfs =
=46C
> information or to help make your driver smaller. =A0I thought you wer=
e
> going to fix this after this was noted in your first submission to
> linux-scsi on 24 September?
>
> James
>
>

Hi James,

We removed Brocade specific sysfs code after first linux-scsi
submission. Can you please
clarify where we are still not using the FC transport class to export
common sysfs FC
information? We do use the fc transport template to create the common
sysfs FC attributes
(in bfad_attr.c) under /sys/class/fc_host/<host#>

Thanks

Jing
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
