From: Loc Ho <lho-qTEPVZfXA3Y@public.gmane.org>
Subject: Re: [PATCH v8 3/4] ata: Add APM X-Gene SoC SATA host controller driver
Date: Tue, 14 Jan 2014 08:37:18 -0800
Message-ID: <CAPw-ZTn7QZkPGLMYkd0m4uS_vC53bOfv-N7M=jUTnzMSVJkMrw@mail.gmail.com>
References: <52D052F9.8050703@redhat.com>
	<20140111193104.GD3257@mtj.dyndns.org>
	<6EB44142-06DA-4C9D-8999-CFA9EE30E03D@apm.com>
	<20140112114958.GA8509@mtj.dyndns.org>
	<CAPw-ZTmfKfPY3DRfJT6FQP78ULwfcjGG76cNfr9yk7UMdrO4wg@mail.gmail.com>
	<20140113160843.GB29053@htj.dyndns.org>
	<CAPw-ZT=A=c9-3BfP-LoDBXByQqfvATpAdS4NPPWB9+R1+GHfDA@mail.gmail.com>
	<20140114160312.GH12131@htj.dyndns.org>
	<20140114160419.GI12131@htj.dyndns.org>
	<CAPw-ZTmn6JiDku=vz=m9v5MNuFrK_-d0ehU_88drCYGHM8Wv=Q@mail.gmail.com>
	<20140114163008.GJ12131@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140114163008.GJ12131-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Milburn <dmilburn-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org" <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "patches-qTEPVZfXA3Y@public.gmane.org" <patches-qTEPVZfXA3Y@public.gmane.org>, Tuan Phan <tphan-qTEPVZfXA3Y@public.gmane.org>, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

>> In the ISR, the AHCI library code reads the CI register and then
>> performs XOR to determine which commands are completed. Then it goes
>> and processes the completed command(s). I am worry that the process of
>> processing the completed command(s), the upper layer may act on the
>> data before the data arrived at the DDR/cache. In answering your
>> question, yes.
>
> Is this an explicit errata on the hardware?  Have you actually
> observed this or is it just a speculation?
>

This issue has NOT been observed but the design has this issue and
observed from verification. As a mean to ensure that this never occur
from design itself, this is the workaround and only apply to SATA and
SDIO. The SDIO don't need this special flush as discussed in earlier
email.

-Loc
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
