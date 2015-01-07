From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: block: remove artifical max_hw_sectors cap
Date: Wed, 07 Jan 2015 15:32:41 +0100
Message-ID: <54AD4389.6030107@profihost.ag>
References: <5497F319.20802@profihost.ag> <20141223082805.GA2303@lst.de> <1420583956.6927.61.camel@haakon3.risingtidesystems.com> <20150107143150.GC659@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ph.de-nserver.de ([85.158.179.214]:47106 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbbAGOcn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2015 09:32:43 -0500
In-Reply-To: <20150107143150.GC659@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org


Am 07.01.2015 um 15:31 schrieb Christoph Hellwig:
> On Tue, Jan 06, 2015 at 02:39:16PM -0800, Nicholas A. Bellinger wrote:
>> The fabric_max_sectors=8192 value is already being exposed by target in
>> block limits EVPD as MAXIMUM TRANSFER LENGTH.
>>
>> I'm guessing that since the host side support was not added until June
>> 2014 in commit bcdb247c by MKP, Stefan is likely using an earlier
>> initiator that is not honoring this value.
> 
> If I understand Stefan correct he was using a recent 3.19-rc kernel,
> which contains my commit in the subject that stops capping the
> max_sectors used by the kernel below that which the hardware supports.
> 
> Given that LIO actually implements the block limits EVPD that suggests
> we're not properly using that information.
> 
> Stefant, what does:
> 
> sg_vpd -p bl /dev/sdX
> 
> for the LIO device tell?

I'm sorry i'm using a 3.10.63 vanilla kernel. So i'm missing a commit?

Stefan
