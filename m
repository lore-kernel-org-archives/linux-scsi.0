From: Masanari Iida <standby24x7@gmail.com>
Subject: Re: [PATCH] [trivial] pm8001: Fix typo in pm8001_hwi.c
Date: Fri, 3 Feb 2012 02:27:02 +0900
Message-ID: <CALLJCT2reS9VHHZ1ejNpFiQz-mN17s7jiyR0d_0MQnhxuDLHtA@mail.gmail.com>
References: <1328191660-2037-1-git-send-email-standby24x7@gmail.com>
	<1328202004.18641.28.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1328202004.18641.28.camel@joe2Laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: jack_wang@usish.com, lindar_liu@usish.com, linux-scsi@vger.kernel.org, trivial@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 3, 2012 at 2:00 AM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2012-02-02 at 23:07 +0900, Masanari Iida wrote:
>> Correct typo "deviece" to "device" in
>> drivers/scsi/pm8001/pm8001_hwi.c
> []
>> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/=
pm8001_hwi.c
> []
>> @@ -3532,7 +3532,7 @@ static void process_one_iomb(struct pm8001_hba=
_info *pm8001_ha, void *piomb)
>> []
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pm8001_printk("unresgister=
 the deviece\n"));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pm8001_printk("unresgister=
 the device\n"));
>
> another typo of unregister
>
Thanks
I just sent v2 patch to the list.

Masanari
