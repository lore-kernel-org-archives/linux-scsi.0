From: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
Subject: Re: [PATCH v3 2/2] ata: ahci_xgene: Add AHCI Support for 2nd HW
 version of APM X-Gene SoC AHCI SATA Host controller.
Date: Mon, 4 May 2015 10:03:49 +0530
Message-ID: <CAOHikRA218vae6Ch+j5SeK0=3uTuZnTDi=W+dtEnYRDZasV2Xg@mail.gmail.com>
References: <1430667220-23477-1-git-send-email-stripathi@apm.com>
	<1430667220-23477-3-git-send-email-stripathi@apm.com>
	<CAGRGNgWGk9jkg3Kui5BdFNhpCKOhD=SCW4apmzqMNHKfVbKMmw@mail.gmail.com>
	<CAOHikRDsnywXaSW8XZiOq-uq9fHiwhp0uxXzHF-ysUO_VmQYFw@mail.gmail.com>
	<CAGRGNgX8d0vMDzTH2mPnkwgBk7RJGWVReSyMC3nS=G0z0XvdYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGRGNgX8d0vMDzTH2mPnkwgBk7RJGWVReSyMC3nS=G0z0XvdYQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Julian Calaby <julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Mailing List, Arm" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Mark Langsdorf <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jon Masters <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, patches <patches-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi Julian,

On Mon, May 4, 2015 at 8:52 AM, Julian Calaby <julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Suman,
>
> On Mon, May 4, 2015 at 12:51 PM, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org> wrote:
>> Hi Julian.
>>
>> On Mon, May 4, 2015 at 5:56 AM, Julian Calaby <julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> Hi Suman,
>>>
>>> On Mon, May 4, 2015 at 1:33 AM, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org> wrote:
>>>> This patch enables full AHCI feature support for APM X-Gene SoC SATA
>>>> host controller. The following errata's are removed:
>>>>
>>>> 1. 2a0bdff6b95 ("ahci-xgene: fix the dma state machine lockup for the
>>>>                  IDENTIFY DEVICE PIO mode command")
>>>> 2. 09c32aaa368 ("ahci_xgene: Fix the dma state machine lockup for the
>>>>                  ATA_CMD_SMART PIO mode command")
>>>> 3. 1540035da71 ("ahci_xgene: Implement the xgene_ahci_poll_reg_val to
>>>>                  support PMP")
>>>> 4. a3a84bc7c88 ("ahci_xgene: Implement the workaround to support PMP
>>>>                  enumeration and discovery")
>>>> 5. 1102407bb71 ("ahci_xgene: Fix the DMA state machine lockup for the
>>>>                  ATA_CMD_PACKET PIO mode command")
>>>> 6. 72f79f9e35b ("ahci_xgene: Removing NCQ support from the APM X-Gene
>>>>                 SoC AHCI SATA Host Controller driver")
>>>
>>> Won't this mean that the 1st HW version won't work properly?
>>
>> No it doesn't mean that, It means whatever workaround we had in 1st HW
>> version has been
>> fixed in 2nd HW version.
>
> I'm sorry, I read the description and assumed that these fixes were
> being removed from the driver, hence breaking support for the 1st
> hardware version.
>
> Sorry for the confusion.

No probs ..

>
> Thanks,
>
> --
> Julian Calaby
>
> Email: julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> Profile: http://www.google.com/profiles/julian.calaby/



-- 
Thanks,
with regards,
Suman Tripathi
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
