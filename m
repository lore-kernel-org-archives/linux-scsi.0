From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Subject: Re: [PATCH v5 0/9] snic:initial submission of snic driver for Cisco
 SCSI HBA
Date: Mon, 18 May 2015 04:21:34 +0000
Message-ID: <D17F6556.25AFA%nmusini@cisco.com>
References: <1429694642-22309-1-git-send-email-nmusini@cisco.com>
 <1431704986.2295.2.camel@HansenPartnership.com>
 <D17C16FC.25A05%nmusini@cisco.com>
 <1431707688.26877.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-2.cisco.com ([173.37.142.89]:47866 "EHLO
	alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbbEREVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2015 00:21:37 -0400
In-Reply-To: <1431707688.26877.3.camel@HansenPartnership.com>
Content-Language: en-US
Content-ID: <B98265C46F2C1F41A30B40831A1982F3@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>

Hi James,

     Added dependency in Kconfig for x86 to avoid its inclusion on other
architectures. Will it be help, if it is changed to x86_64?.

Thanks
simha

On 15/05/15 10:04 pm, "James Bottomley"
<James.Bottomley@HansenPartnership.com> wrote:

>On Fri, 2015-05-15 at 16:08 +0000, Narsimhulu Musini (nmusini) wrote:
>> Hi James,
>> 
>> >>This doesn't build on 32 bits.  Is it supposed to be 64 bit only?
>> Yes please, x86_64 arch only.
>
>For the kernel, we don't usually accept architectural restrictions.
>You're perfectly entitled to support only the architectures you wish
>(and put a warning in the driver if you want) but we do need the code to
>be endian and bitwidth clean because we find it helps with maintenance
>and checking (the ppc build systems pick up quite a few snafus that the
>x86 ones don't).
>
>James
>
>

