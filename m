From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 11/32] scsi: hisi_sas: add phy SAS ADDR initialization
Date: Mon, 9 Nov 2015 16:51:12 +0000
Message-ID: <5640CF00.2030003@huawei.com>
References: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
 <1447086757-147706-12-git-send-email-john.garry@huawei.com>
 <4369607.QVA3rBnZUm@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4369607.QVA3rBnZUm@wuerfel>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: JBottomley-wo1vFcy6AUs@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 09/11/2015 16:28, Arnd Bergmann wrote:
> On Tuesday 10 November 2015 00:32:16 John Garry wrote:
>>   }
>>
>> +static void hisi_sas_init_add(struct hisi_hba *hisi_hba)
>> +{
>> +       int i;
>> +
>> +       for (i = 0; i < hisi_hba->n_phy; i++)
>> +               memcpy(&hisi_hba->phy[i].dev_sas_addr,
>> +                      hisi_hba->sas_addr,
>> +                      SAS_ADDR_SIZE);
>> +}
>
> I don't know the background here, but I thought it would have to
> be a different address on each phy. Are you sure this is not the
> case?
>
> 	Arnd
>
> .
>

Hi,

Each controller should have a unique SAS addr but not each phy.

Regards,
john

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
