From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] ata: fixes kernel crash while tracing
 ata_eh_link_autopsy event
Date: Wed, 1 Nov 2017 07:30:47 -0700
Message-ID: <20171101143031.GL3252168@devbig577.frc2.facebook.com>
References: <1508926976-11467-1-git-send-email-rsahu@apm.com>
 <20171025145450.GA59538@devbig577.frc2.facebook.com>
 <CAFd313w9W2hHFPJ47y0jeNb1u7=0deLtwcRF=+HXGBYft-QaLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFd313w9W2hHFPJ47y0jeNb1u7=0deLtwcRF=+HXGBYft-QaLw@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Rameshwar Sahu <rsahu@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com
List-Id: linux-scsi@vger.kernel.org

Hello,

On Tue, Oct 31, 2017 at 08:52:44PM +0530, Rameshwar Sahu wrote:
> > probably should take both link and dev and use dev iff it's not NULL.
> >
> 
> Instead of this would it be better to call trace_ata_eh_link_autopsy() if
> dev is not NULL from ata error handler ??

Oh yeah, that'd work too and be probably better.

Thanks.

-- 
tejun
