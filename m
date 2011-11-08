From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: WARNING: at drivers/scsi/scsi_lib.c:1704
Date: Tue, 8 Nov 2011 08:07:37 +0100
Message-ID: <CAO+b5-pPTt9B1se3-oGrZZ4-mScJh7_9MA29UTbOSB3QR4L38A@mail.gmail.com>
References: <20111107172408.834c6ffcecfe35f7452c7e60@canb.auug.org.au>
	<1320677484.1215.10.camel@dabdike.int.hansenpartnership.com>
	<20111108110300.e8494242e6c404142b1fe4c0@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111108110300.e8494242e6c404142b1fe4c0@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 8, 2011 at 1:03 AM, Stephen Rothwell <sfr@canb.auug.org.au>=
 wrote:
> On Mon, 07 Nov 2011 08:51:24 -0600 James Bottomley <James.Bottomley@H=
ansenPartnership.com> wrote:
>>=A0The true fix is to do a proper
>> teardown instead of hand rolling it. =A0Does this fix it for you?
>
> I don't get the WARNING any more, but now get lots of:
>
> scsi: killing requests for dead queue

This patch should help: http://www.spinics.net/lists/linux-scsi/msg5537=
3.html.

Bart.
