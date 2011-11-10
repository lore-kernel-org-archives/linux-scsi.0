From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH v2 0/4] ata port runtime power management support
Date: Thu, 10 Nov 2011 17:02:41 +0100
Message-ID: <CAPXgP12-CxDBa0cHtM+ejczR4131tnvq3N0WKQ5egt4hb31kPg@mail.gmail.com>
References: <1320906166-15459-1-git-send-email-ming.m.lin@intel.com> <20111110153036.GC27258@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20111110153036.GC27258@google.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 10, 2011 at 16:30, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Nov 10, 2011 at 02:22:42PM +0800, Lin Ming wrote:

>> v2 changes it to:
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 /sys/devices/pci0000:00/0000:00:1f.2 =C2=
=A0 =C2=A0(ahci controller)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 |-- ata1 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0(ata port)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |-- host0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 (scsi host)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |-- target0:=
0:0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (scsi targe=
t)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 |-- 0:0:0:0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (d=
isk)
>>
>> So ata port runtime PM will happen as:

>> This is much cleaner and natural.
>
> Yeah, I really like this approach. =C2=A0Nicely done. =C2=A0I *think*=
 the
> hierarchy change should be okay but cc'ing Kay just in case.

Looks good to me. All non-broken users of sysfs should be fine and
cope with changes like this without any problem.

Kay
