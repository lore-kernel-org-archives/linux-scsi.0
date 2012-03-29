From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v3 4/7] libata: detech Device Attention support
Date: Thu, 29 Mar 2012 19:18:19 +0800
Message-ID: <CAF1ivSZdFpd1v15Q+fVkiGZSp_oGT-rLj0K_5AxfC7yADed=hA@mail.gmail.com>
References: <1332915722-15963-1-git-send-email-ming.m.lin@intel.com>
	<1332915722-15963-5-git-send-email-ming.m.lin@intel.com>
	<4F72F45D.7090800@mvista.com>
	<1332997594.3793.118.camel@minggr>
	<4F744412.4090806@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <4F744412.4090806@mvista.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>, Aaron Lu <aaron.lu@amd.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi <linux-acpi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 29, 2012 at 7:14 PM, Sergei Shtylyov <sshtylyov@mvista.com>=
 wrote:
> Hello.
>
>
> On 29-03-2012 9:06, Lin Ming wrote:
>
>>>> Add a new flag ATA_DFLAG_DA to indicate that device supports "Devi=
ce
>>>> Attention".
>
>
>>>> Acked-by: Aaron Lu<aaron.lu@amd.com>
>>>> Signed-off-by: Lin Ming<ming.m.lin@intel.com>
>>>
>>> [...]
>
>
>>>> diff --git a/include/linux/ata.h b/include/linux/ata.h
>>>> index 32df2b6..6ee41cc 100644
>>>> --- a/include/linux/ata.h
>>>> +++ b/include/linux/ata.h
>>>> @@ -578,6 +578,7 @@ static inline int ata_is_data(u8 prot)
>>>> =A0 =A0 =A0 =A0 =A0((u64) (id)[(n) + 0]) )
>>>>
>>>> =A0 #define ata_id_cdb_intr(id) =A0(((id)[ATA_ID_CONFIG]& =A0 0x60=
) =3D=3D 0x20)
>>>> +#define atapi_id_has_da(id) =A0 =A0((id)[77]& =A0 (1<< =A0 4))
>
>
>>> =A0 =A0 We prefix these macros with 'ata_' despite them being appli=
ed to
>>> IDENTIFY
>>> DEVICE data or IDENTIFY PAKCET DEVICE data. ata_id_cdb_intr(), for
>>> example,
>>> applies only to IDENTIFY PAKCET DEVICE data.
>
>
>> OK, will change it.
>
>
> =A0 Also, what does the word "detech" mean in the subject?

Typo! It should be "detect"

>
>
> MBR, Sergei
--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
