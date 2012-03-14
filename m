From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: linux-next: Tree for Mar 13 (ata)
Date: Tue, 13 Mar 2012 17:36:50 -0700
Message-ID: <CAA9_cmf=WzQkDpahv73yBbe1NHTrxV7=K1PToH80K9EY_rzUgg@mail.gmail.com>
References: <20120313204114.e160849af7dbe5a4b4e5c0ad@canb.auug.org.au>
	<4F5FB6F0.6050300@xenotime.net>
	<4F5FBAA3.3080508@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4F5FBAA3.3080508@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 13, 2012 at 2:22 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
> On 03/13/2012 05:06 PM, Randy Dunlap wrote:
>>
>> On 03/13/2012 02:41 AM, Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20120309:
>>
>>
>>
>> on x86_64:
>>
>> ERROR: "ata_sas_port_async_resume" [drivers/scsi/libsas/libsas.ko]
>> undefined!
>> ERROR: "ata_sas_port_async_suspend" [drivers/scsi/libsas/libsas.ko]
>> undefined!
>>
>>
>> # CONFIG_SUSPEND is not set
>> # CONFIG_PM_RUNTIME is not set
>> # CONFIG_ACPI is not set
>
>
> That sounds like the scsi tree (linux-scsi CC added).

That's on me, new suspend/resume support for libsas.  Looks like I
need stubs for the CONFIG_PM=n case.  Revised patches coming up.

--
Dan
