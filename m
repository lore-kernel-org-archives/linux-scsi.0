From: Tejun Heo <tj@kernel.org>
Subject: Re: Do we need to implement sr START/STOP management
Date: Thu, 3 Nov 2011 08:46:27 -0700
Message-ID: <CAOS58YM2rwwaqEBDEHdBy_Mo_3FJsJUsHmdBM=T4hyApmKuOuA@mail.gmail.com>
References: <CADyp2PebObcVyMAA=XzTayiXmBxYRJtR3xY6b3tJYiVA=hCaqQ@mail.gmail.com>
	<1320126812.7701.17.camel@dabdike>
	<CADyp2Pdac=z6KzKnNykBCZNRLnjkv-z901Hwd-U0o2wB2qHWOA@mail.gmail.com>
	<4EB0992C.5070309@gmail.com>
	<CADyp2PcAOAiUbpSq_HmUs-wNqHuzo+7y1mZjJLAGNuO1yAhXEw@mail.gmail.com>
	<CAOS58YOVC-dknjK50LHTjMOFFdM3KNyWzRPs8Ru2YRau4QQBWw@mail.gmail.com>
	<4EB2B468.9010001@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48565 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263Ab1KCPq3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2011 11:46:29 -0400
In-Reply-To: <4EB2B468.9010001@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: JiSheng Zhang <jszhang3@gmail.com>, Robert Hancock <hancockrwd@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Thu, Nov 3, 2011 at 8:34 AM, Douglas Gilbert <dgilbert@interlog.com> wrote:
> That's a pretty poor attitude. I suspect Microsoft care. If so they
> would be transitioning away from TEST UNIT READY to REQUEST SENSE
> to monitor power conditions and the progress indication.

I was talking about media presence polling.  We used to include TUR in
the sequence and there have been some number of devices which worked
fine for a while but lock up eventually.  Windows only issues
CHECK_MEDIA_EVENT_STATUS so nobody has tested extended TUR cycles and
nobody is fixing an optical drive EOL'd six months ago either, so what
I or you think or feel doesn't matter in the end.  The most important
thing is we provide drivers which allow proper operation and, sadly,
at this point, the best way to get there is following what windows
does.  It's not like we lose any functionality that way anyway.

If windows isn't spinning down the drive, it is highly unlikely that
missing that harms anything and it's highly like there are a bunch of
devices which would go "uh... what the hell is this? I don't know
this. osidfjalekjalkgjs".  So, there simply is no point at all.

Thanks.

-- 
tejun
