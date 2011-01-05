From: DuanZhenzhong <zhenzhong.duan@oracle.com>
Subject: Re: declare MODULE_FIRMWARE in libsas
Date: Wed, 05 Jan 2011 11:18:45 +0800
Message-ID: <4D23E315.9060900@oracle.com>
References: <4D22CF9F.1070005@oracle.com> <1294150132.4726.0.camel@mulgrave.site> <4D235CAC.5070309@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:18181 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab1AEDUK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2011 22:20:10 -0500
In-Reply-To: <4D235CAC.5070309@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Jeff Garzik =E5=86=99=E9=81=93:
> On 01/04/2011 09:08 AM, James Bottomley wrote:
>> On Tue, 2011-01-04 at 15:43 +0800, DuanZhenzhong wrote:
>>> Signed-off-by: Zhenzhong Duan<zhenzhong.duan@oracle.com>
>>>
>>> ---
>>
>> Description?  Since libsas has no firmware, surely some explanation =
is
>> required.
>
> Indeed.  Looks bogus at first glance?
>
>
I was finding all requested but not exported firmware in scsi driver fo=
r=20
generating dump initrd use.
In sas_scsi_host.c, request_firmware is called with "sas_addr", sas_add=
r=20
neither builtin nor exported. Don't sas_addr a firmware? Please correct=
=20
me. thanks

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
