From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH 16/20] [SCSI] mpt3sas: Added support for customer specific branding
Date: Mon, 22 Jun 2015 17:56:58 +0530
Message-ID: <CAK=zhgoY6s1hVzWnPKTf0iMKoFJeJ+D6xcXFAf1mQLAHMSiZ4g@mail.gmail.com>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1434102153-38581-17-git-send-email-Sreekanth.Reddy@avagotech.com>
	<yq1k2uza0n5.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33844 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933692AbbFVM1A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2015 08:27:00 -0400
Received: by wicnd19 with SMTP id nd19so74978074wic.1
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2015 05:26:58 -0700 (PDT)
In-Reply-To: <yq1k2uza0n5.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Sat, Jun 20, 2015 at 2:14 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:
>
>> Added support for below customer specific brandings "VendorID"
>> "DeviceID" "SubsystemVendor ID" "SubsystemDevice ID" Cisco Branding
>> String 0x1000 0x97 0x1137 0x154 Cisco 9300-8i 12Gbps SAS HBA 0x1000
>> 0x97 0x1137 0x155 Cisco 12G Modular SAS Pass through Controller 0x1000
>> 0x97 0x1137 0x156 UCS C3X60 12G SAS Pass through Controller
>
> Same comment about not actually changing driver behavior.
>
> These changes belong in pci.ids, not in a driver.

Yes Martin, I agree with you that these changes belong in pci.ids. But
Customers are asking us to print the HBA branding name while loading
the driver on their custom HBA's.

>
> --
> Martin K. Petersen      Oracle Linux Engineering



-- 

Regards,
Sreekanth
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
