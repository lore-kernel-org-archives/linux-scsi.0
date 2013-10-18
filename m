From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH 1/1] remove cpqarray from mainline kernel
Date: Fri, 18 Oct 2013 16:57:07 +0000
Message-ID: <48275AD710FCA34184C2B6186B4016B32D15F761@G6W2491.americas.hpqcorp.net>
References: <20131017175226.GA31535@thumper.usa.hp.com>
 <20131017141337.425f84c630ffe1c7c61c4dc4@linux-foundation.org>
 <20131017223616.GB32575@kernel.dk>
 <48275AD710FCA34184C2B6186B4016B32D15F735@G6W2491.americas.hpqcorp.net>
 <526167ED.1010503@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <526167ED.1010503@kernel.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Friday, October 18, 2013 11:55 AM
> To: Miller, Mike (OS Dev); Andrew Morton
> Cc: LKML-scsi; LKML
> Subject: Re: [PATCH 1/1] remove cpqarray from mainline kernel
> 
> On 10/18/2013 10:22 AM, Miller, Mike (OS Dev) wrote:
> >
> >
> >> -----Original Message-----
> >> From: Jens Axboe [mailto:axboe@kernel.dk]
> >> Sent: Thursday, October 17, 2013 5:36 PM
> >> To: Andrew Morton
> >> Cc: Miller, Mike (OS Dev); LKML-scsi; LKML
> >> Subject: Re: [PATCH 1/1] remove cpqarray from mainline kernel
> >>
> >> On Thu, Oct 17 2013, Andrew Morton wrote:
> >>> On Thu, 17 Oct 2013 12:52:26 -0500 Mike Miller <mike.miller@hp.com>
> >> wrote:
> >>>
> >>>> cpqarray hasn't been used in over 12 years. It's doubtful that
> >>>> anyone still uses the board. It's time the driver was removed from
> >>>> the
> >> mainline kernel.
> >>>> The only updates these days are minor and mostly done by people
> >> outside of HP.
> >>>
> >>> It's amazing the weird stuff people get up to.  Perhaps we should
> >>> disable it in config for a cycle or two, see if that flushes anyone out?
> >>
> >> I think that would be prudent, you never know what people run...
> >>
> >> --
> >> Jens Axboe
> >
> > I agree with Andrew's suggestion. Should I submit a patch that only
> removes cpqarray from config?
> 
> I put one in yesterday:
> 
> http://git.kernel.dk/?p=linux-
> block.git;a=commit;h=f504954db0ecccaded5397e3432cdaf7175602fb
> 
> --
> Jens Axboe

Thanks, Jens.
