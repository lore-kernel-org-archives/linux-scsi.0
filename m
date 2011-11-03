From: Tejun Heo <tj@kernel.org>
Subject: Re: Do we need to implement sr START/STOP management
Date: Thu, 3 Nov 2011 14:04:33 -0700
Message-ID: <20111103210433.GL4417@google.com>
References: <CADyp2PebObcVyMAA=XzTayiXmBxYRJtR3xY6b3tJYiVA=hCaqQ@mail.gmail.com>
 <1320126812.7701.17.camel@dabdike>
 <CADyp2Pdac=z6KzKnNykBCZNRLnjkv-z901Hwd-U0o2wB2qHWOA@mail.gmail.com>
 <4EB0992C.5070309@gmail.com>
 <CADyp2PcAOAiUbpSq_HmUs-wNqHuzo+7y1mZjJLAGNuO1yAhXEw@mail.gmail.com>
 <CAOS58YOVC-dknjK50LHTjMOFFdM3KNyWzRPs8Ru2YRau4QQBWw@mail.gmail.com>
 <4EB2B468.9010001@interlog.com>
 <CAOS58YM2rwwaqEBDEHdBy_Mo_3FJsJUsHmdBM=T4hyApmKuOuA@mail.gmail.com>
 <4EB2CBAC.70003@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4EB2CBAC.70003@interlog.com>
Sender: linux-ide-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: JiSheng Zhang <jszhang3@gmail.com>, Robert Hancock <hancockrwd@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Thu, Nov 03, 2011 at 01:13:16PM -0400, Douglas Gilbert wrote:
> Do you mean the GET EVENT STATUS NOTIFICATION command (as there is
> no CHECK MEDIA EVENT STATUS command in SCSI or ATA)? If so it is
> one of the "good guys" along with the REQUEST SENSE command. And
> as I said TUR is not recommended. So looking at MS usage _and_
> the standards is a useful guide.

Yes, that's the one.  Sorry, I always get confused about its name.
IIRC, it's a relatively new command, right?  Anyways, I'm not arguing
standards are useless but that actual usages have to take precedence.

> I agree. SCSI and ATA define idle states (with some fuzziness in
> the naming) that have timers associated with them. Those
> mechanisms seem to work pretty well without the intervention of
> commands like START STOP UNIT.

Cool, thanks.

-- 
tejun
