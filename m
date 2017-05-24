From: "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>
Subject: Re: [PATCH] qla2xxx: don't disable a not previously enabled PCI
 device
Date: Wed, 24 May 2017 17:12:19 +0000
Message-ID: <D54B0CBF.941D8%giridhar.malavali@cavium.com>
References: <20170523145047.5020-1-jthumshirn@suse.de>
 <1495640832.2823.5.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1495640832.2823.5.camel@sandisk.com>
Content-Language: en-US
Content-ID: <7117F73BA2C59B4E8C2B23F874A69368@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@cavium.com>
List-Id: linux-scsi@vger.kernel.org



On 5/24/17, 8:47 AM, "Bart Van Assche" <Bart.VanAssche@sandisk.com> wrote:

>On Tue, 2017-05-23 at 16:50 +0200, Johannes Thumshirn wrote:
>> When pci_enable_device() or pci_enable_device_mem() fail in
>> qla2x00_probe_one() we bail out but do a call to
>> pci_disable_device(). This causes the dev_WARN_ON() in
>> pci_disable_device() to trigger, as the device wasn't enabled
>> previously.
>>=20
>> So instead of taking the 'probe_out' error path we can directly return
>> *iff* one of the pci_enable_device() calls fails.
>>=20
>> Additionally rename the 'probe_out' goto label's name to the more
>> descriptive 'disable_device'.
>>=20
>> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
>> Fixes: e315cd28b9ef ("[SCSI] qla2xxx: Code changes for qla data
>>structure refactoring")
>
>Hello Johannes,
>
>Please consider adding a Cc: stable tag to this patch. Since otherwise
>this
>patch looks fine to me:
>
>Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

Looks good to me.=20

Reviewed-by: Giridhar Malavali <giridhar.malavali@cavium.com>
