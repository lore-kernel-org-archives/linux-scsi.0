From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v5 04/12] libata: use correct PCI devices
Date: Mon, 18 Jun 2012 20:03:46 +0800
Message-ID: <CAF1ivSaiVGB+TSn80QijpWJWUdkhpjuOKuu9XSTROF-kGgP_gQ@mail.gmail.com>
References: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
	<1340000766-129148-5-git-send-email-ming.m.lin@intel.com>
	<4FDF12F0.6080205@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <4FDF12F0.6080205@mvista.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, David Woodhouse <David.Woodhouse@intel.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 18, 2012 at 7:37 PM, Sergei Shtylyov <sshtylyov@mvista.com>=
 wrote:
> On 18-06-2012 10:25, Lin Ming wrote:
>
>> From: Holger Macht <holger@homac.de>
>
>
>> Commit 9a6d6a2ddabbd32c07f6a38b659e5f3db319fa5a
>
>
> =A0 Please also specify that commit's summary in parens.

OK.

Thanks,
Lin Ming

>
>
>> made ata ports parent
>> devices of scsi hosts, so we need to go yet another level up to be a=
ble
>> to use the correct PCI devices.
>
>
>> Signed-off-by: Holger Macht <holger@homac.de>
>> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
>
>
> MBR, Sergei
--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
