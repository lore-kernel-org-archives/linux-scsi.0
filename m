From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: advansys needs ISA dma api for ISA support
Date: Fri, 16 Oct 2015 13:49:06 +0200
Message-ID: <5620E432.1000709@suse.de>
References: <5081546.QjQ32dGX2L@wuerfel> <561F96B7.4050300@suse.de>
 <561F977B.1030009@suse.de> <8749889.aUxSEGWaCq@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbbJPLtI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Oct 2015 07:49:08 -0400
In-Reply-To: <8749889.aUxSEGWaCq@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: linux-scsi@vger.kernel.org, JBottomley@odin.com, linux-kernel@vger.kernel.org

On 10/15/2015 05:04 PM, Arnd Bergmann wrote:
> On Thursday 15 October 2015 14:09:31 Hannes Reinecke wrote:
>> On 10/15/2015 02:06 PM, Hannes Reinecke wrote:
>>> On 10/12/2015 05:10 PM, Arnd Bergmann wrote:
>>>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>>>> index d2f480b04a52..d4aa6a1a806c 100644
>>>> --- a/drivers/scsi/Kconfig
>>>> +++ b/drivers/scsi/Kconfig
>>>> @@ -499,6 +499,7 @@ config SCSI_ADVANSYS
>>>>      tristate "AdvanSys SCSI support"
>>>>      depends on SCSI
>>>>      depends on ISA || EISA || PCI
>>>> +    depends on ISA_DMA_API || !ISA
>>>>      help
>>>>        This is a driver for all SCSI host adapters manufactured by
>>>>        AdvanSys. It is documented in the kernel source in
>>>>
>>> Sorry to chime in again, but wouldn't this allow to build on platfo=
rms
>>> which have neither ISA_DMA_API nor ISA, like oldish sparc systems w=
ith
>>> proprietary S-BUS?
>=20
> No, the first dependency is still in place. It could also be written =
as
>=20
> depends on (ISA && ISA_DMA_API) || EISA || PCI
>=20
> which might be easier to understand. Do you want me to resubmit it li=
ke that?
>=20
Yes, please do so.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
