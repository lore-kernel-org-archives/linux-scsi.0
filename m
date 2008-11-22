From: "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: Re: Question regarding SAS controllers.
Date: Sat, 22 Nov 2008 22:21:21 +0000
Message-ID: <20081122222120.GA12360@gallifrey>
References: <660360F4F2570145BD872F298951B17A5CC40737@cosmail03.lsi.com> <alpine.DEB.1.10.0811221658280.707@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755750AbYKVWVr@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811221658280.707@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org

* Justin Piszcz (jpiszcz@lucidpixels.com) wrote:

<snip>

> Eric,
> 
> Thanks, I had checked this out earlier but the only non-raid SAS HBAs 
> (those HBAs that do not end in -R) that are JBOD seem to be external only
> (e.g., do not contain any internal SAS ports?)
> 
> Justin.

For some of the SAS cards that LSI produce there are 2 sets of firmware
on their site and you can load the non-RAID firmware; both versions
will let you drive stuff as individual drives (e.g. tape drives or
inidivudal discs) but the non-RAID firmware is a LOT faster for that.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
