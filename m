From: Rameshwar Sahu <rsahu@apm.com>
Subject: Re: [PATCH] ata: fixes kernel crash while tracing ata_eh_link_autopsy event
Date: Thu, 2 Nov 2017 15:27:25 +0530
Message-ID: <CAFd313w-SKoLR5J4qDDCnDG=OpcRXGL7DqTpy7_tuxzcFyrVdw@mail.gmail.com>
References: <1508926976-11467-1-git-send-email-rsahu@apm.com>
 <20171025145450.GA59538@devbig577.frc2.facebook.com> <CAFd313w9W2hHFPJ47y0jeNb1u7=0deLtwcRF=+HXGBYft-QaLw@mail.gmail.com>
 <20171101143031.GL3252168@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20171101143031.GL3252168@devbig577.frc2.facebook.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: olof@lixom.net, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 1, 2017 at 8:00 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Tue, Oct 31, 2017 at 08:52:44PM +0530, Rameshwar Sahu wrote:
>> > probably should take both link and dev and use dev iff it's not NULL.
>> >
>>
>> Instead of this would it be better to call trace_ata_eh_link_autopsy() if
>> dev is not NULL from ata error handler ??
>
> Oh yeah, that'd work too and be probably better.
I will post another  version with this fix.
>
> Thanks.
>
> --
> tejun
