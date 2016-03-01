From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 0/6] ncr5380: Exception handling fixes for v4.5
Date: Tue, 1 Mar 2016 14:32:23 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1603011431300.3734@nippy.intranet>
References: <20160222230703.994951661@telegraphics.com.au> <yq1d1rfc4iw.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <yq1d1rfc4iw.fsf@sermon.lab.mkp.net>
Sender: linux-m68k-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Mon, 29 Feb 2016, Martin K. Petersen wrote:

> >>>>> "Finn" == Finn Thain <fthain@telegraphics.com.au> writes:
> 
> Finn> These patches fix some exception handling and autosense bugs that
> Finn> I accidentally introduced in v4.5-rc1.
> 
> Finn> drivers/scsi/NCR5380.c       |  133 +++++++++++++++++++------------------------
> Finn> drivers/scsi/atari_NCR5380.c |  133 +++++++++++++++++++------------------------
> Finn> 2 files changed, 118 insertions(+), 148 deletions(-)
> 
> This is a pretty big lump of changes for a 4.5 bug fix!

I'm sure this is a lot of rework when compared to the high standard set by 
well-funded corporate contributions.

However, I don't have anyone paying me to write and execute thorough test 
plans for error paths on a wide variety of different hardware platforms.

Nonetheless, these error paths have now been thoroughly tested on several 
platforms.

Please keep in mind that these fixes are all rework of the changes I made 
in -rc1. So this submission is
   2 files changed, 118 insertions(+), 148 deletions(-)
which is all rework of the previous submission, which was
   18 files changed, 2940 insertions(+), 3688 deletions(-)

Better than 5% rate of rework. Bugs-per-line-of-code should drop quite 
quickly at that rate, presuming fixes get merged.

> 
> Given the limited exposure based on the nature of the affected hardware 
> I have queued them for 4.6.
> 

The affected hardware doesn't matter (though it is likely outside of any 
commercial support contract). It's the affected users that interest me.

-- 
