From: Rameshwar Sahu <rsahu-qTEPVZfXA3Y@public.gmane.org>
Subject: Re: [PATCH] ata: xgene: Enable NCQ support for APM X-Gene SATA
 controller hardware v1.1
Date: Fri, 11 Nov 2016 13:36:28 +0530
Message-ID: <CAFd313ycmpdp7wHCVRJrigJV31hLwBGOo=FNENwgFnNKyVkQBA@mail.gmail.com>
References: <1469524857-3720-1-git-send-email-rsahu@apm.com>
 <CAFd313x-mXpy0N3aKx2rfoag1FNOrN-LzKb5UHkY2L+GGc0B-A@mail.gmail.com> <20161109164531.GA14630@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161109164531.GA14630-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devicetree List <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arm <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, patches <patches-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi Tejun,

On Wed, Nov 9, 2016 at 10:15 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Wed, Sep 14, 2016 at 04:15:00PM +0530, Rameshwar Sahu wrote:
>> > @@ -821,8 +823,6 @@ static int xgene_ahci_probe(struct platform_device
>> > *pdev)
>> >                                 dev_warn(&pdev->dev, "%s: Error reading
>> > device info. Assume version1\n",
>> >                                         __func__);
>> >                                 version = XGENE_AHCI_V1;
>> > -                       } else if (info->valid & ACPI_VALID_CID) {
>> > -                               version = XGENE_AHCI_V2;
>
> Can you please explain this part a bit?  Everything else looks good to
> me.

Here we should not assume XGENE_AHCI_V2 always in case of having valid
_CID in ACPI table.
I need to remove this assumption because V1_1 has also valid _CID for
backward compatibly with v1.
>
> Thanks.
>
> --
> tejun
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
