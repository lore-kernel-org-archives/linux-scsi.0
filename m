From: Suman Tripathi <stripathi@apm.com>
Subject: Re: [PATCH v6 1/1] ata: ahci_xgene: Add AHCI Support for 2nd HW
 version of APM X-Gene SoC AHCI SATA Host controller.
Date: Mon, 11 May 2015 19:01:32 +0530
Message-ID: <CAOHikRBC_KOtL=hJHp7D+9DWNOnuN=VE=RQEnU_TJJ6wOXkO9g@mail.gmail.com>
References: <1431333375-30433-1-git-send-email-stripathi@apm.com>
	<1431333375-30433-2-git-send-email-stripathi@apm.com>
	<20150511112800.GA11388@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:33136 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754152AbbEKNbf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 09:31:35 -0400
Received: by wiun10 with SMTP id n10so96481123wiu.1
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2015 06:31:32 -0700 (PDT)
In-Reply-To: <20150511112800.GA11388@htj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Mark Langsdorf <mlangsdo@redhat.com>, Jon Masters <jcm@redhat.com>, patches <patches@apm.com>

Hi Tejun,

On Mon, May 11, 2015 at 4:58 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Suman.
>
> On Mon, May 11, 2015 at 02:06:15PM +0530, Suman Tripathi wrote:
>> -#ifdef CONFIG_ACPI
>> -static const struct acpi_device_id xgene_ahci_acpi_match[] = {
>> -     { "APMC0D0D", },
>> -     { }
>> -};
>> -MODULE_DEVICE_TABLE(acpi, xgene_ahci_acpi_match);
>> -#endif
>> -
>> -static const struct of_device_id xgene_ahci_of_match[] = {
>> -     {.compatible = "apm,xgene-ahci"},
>> -     {},
>> -};
>> -MODULE_DEVICE_TABLE(of, xgene_ahci_of_match);
>
> I applied the patch as-is this time but please don't combine code
> movement with actual changes in the future.  Split them out to
> separate patches.  It makes the changes a lot easier to follow and
> verify.

Sorry . I will take care of it next time onwards.
>
> Thanks.
>
> --
> tejun



-- 
Thanks,
with regards,
Suman Tripathi
