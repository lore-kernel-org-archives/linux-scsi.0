From: "Hiral Patel (hiralpat)" <hiralpat@cisco.com>
Subject: Re: [scsi:for-next 23/27] drivers/scsi/fnic/fnic_scsi.c:183:35:
 sparse: invalid assignment: &=
Date: Wed, 30 Jan 2013 00:17:21 +0000
Message-ID: <DF334AB4E0858445841A5B5201E1C1B128919451@xmb-rcd-x08.cisco.com>
References: <1359429414.2408.22.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:18660 "EHLO
	rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3A3ASZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jan 2013 19:18:25 -0500
In-Reply-To: <1359429414.2408.22.camel@dabdike>
Content-Language: en-US
Content-ID: <34B068AA46F3034684C0FFCEC2DAAB25@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>

Hi James,

Sorry, somehow I missed looking at kbuild emails. I have fixed sparse and
smatch issues and resubmitted patches 3-10.

Thanks,
Hiral

On 1/28/13 7:16 PM, "James Bottomley"
<James.Bottomley@HansenPartnership.com> wrote:

>On Mon, 2012-12-17 at 21:50 +0800, kbuild test robot wrote:
>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
>>for-next
>> head:   e3ff197a750d2912d0bb2a0161c23c18bad250ad
>> commit: 188061001ac78b40780af042dd2156e2213e29ed [23/27] [SCSI]
>>fnic:fixing issues in device and firmware reset code
>> 
>> 
>> sparse warnings:
>> 
>> + drivers/scsi/fnic/fnic_scsi.c:183:35: sparse: invalid assignment: &=
>> drivers/scsi/fnic/fnic_scsi.c:183:35:    left side has type restricted
>>unsigned long long
>> drivers/scsi/fnic/fnic_scsi.c:183:35:    right side has type unsigned
>>long long
>> drivers/scsi/fnic/fnic_scsi.c:185:35: sparse: invalid assignment: |=
>> drivers/scsi/fnic/fnic_scsi.c:185:35:    left side has type restricted
>>unsigned long long
>> drivers/scsi/fnic/fnic_scsi.c:185:35:    right side has type unsigned
>>long long
>
>I still haven't seen fixes for these patches.  I've flushed the fnic
>patches from the tree pending resolution.  That means the only remaining
>fnic patches I have are
>
>1/10 fnic: updated MAINTAINERS list
>2/10 fnic: fix for trusted cos
>
>Please fix this and the smatch issues and resubmit the other eight.
>
>Thanks,
>
>James
>
>

