From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/6] ncr5380: Exception handling fixes for v4.5
Date: Tue, 01 Mar 2016 08:00:22 -0500
Message-ID: <yq17fhmcpzt.fsf@sermon.lab.mkp.net>
References: <20160222230703.994951661@telegraphics.com.au>
	<yq1d1rfc4iw.fsf@sermon.lab.mkp.net>
	<alpine.LNX.2.00.1603011431300.3734@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1603011431300.3734@nippy.intranet> (Finn Thain's
	message of "Tue, 1 Mar 2016 14:32:23 +1100 (AEDT)")
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Finn" == Finn Thain <fthain@telegraphics.com.au> writes:

Finn,

>> This is a pretty big lump of changes for a 4.5 bug fix!

Finn> Please keep in mind that these fixes are all rework of the changes
Finn> I made in -rc1. So this submission is 2 files changed, 118
Finn> insertions(+), 148 deletions(-) which is all rework of the
Finn> previous submission, which was 18 files changed, 2940
Finn> insertions(+), 3688 deletions(-)

I am well aware of and appreciate the huge amount of work you have done.

My concern is merely that Linus is going to get pretty upset with such a
big delta this late in the 4.5 cycle. By comparison, our other fixes at
this time are in the 1-5 line bucket!

I think putting the fixes into 4.6 and tagging them for stable is a
better (less emperor penguin wrath-inducing) approach.

-- 
Martin K. Petersen	Oracle Linux Engineering
