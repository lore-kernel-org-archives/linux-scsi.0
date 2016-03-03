From: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v9 3/3] add support for DWC UFS Host Controller
Date: Thu, 3 Mar 2016 14:17:28 +0000
Message-ID: <56D84778.50509@synopsys.com>
References: <cover.1455549221.git.jpinto@synopsys.com>
 <10452689.JXS9XIs74z@wuerfel> <56D841A7.7050008@synopsys.com>
 <12939431.liKZREJb7L@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <12939431.liKZREJb7L@wuerfel>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Cc: vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, CARLOS.PALMINHA-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


On 3/3/2016 2:12 PM, Arnd Bergmann wrote:
> On Thursday 03 March 2016 13:52:39 Joao Pinto wrote:
>>
>> config SCSI_UFS_DWC
>>         bool
>>
>> config SCSI_UFS_DWC_TC_PLATFORM
>>         tristate "DesignWare platform support using a G210 Test Chip"
>>         depends on SCSI_UFSHCD_PLATFORM
>>         select SCSI_UFS_DWC
>>         ---help---
>>           Synopsys Test Chip is a PHY for prototyping purposes.
>>
>>           If unsure, say N."
>>
>> config SCSI_UFS_DWC_TC_PCI
>>         tristate "DesignWare pci support using a G210 Test Chip"
>>         depends on SCSI_UFSHCD_PCI
>>         select SCSI_UFS_DWC
>>         ---help---
>>           Synopsys Test Chip is a PHY for prototyping purposes.
>>
>>           If unsure, say N."
>>
>> I would keep SCSI_UFS_DWC to avoid building DWC specific source everytime.
>>
>> Agree?
>>
> 
> Yes, looks good to me.
> 
> 	Arnd
> 

Nice! Thanks for the inputs. I'm going to implement the changes and send a v10 soon.

Joao
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
