From: Philippe Troin <phil@fifi.org>
Subject: Re: more aic7xxx boot failure
Date: 24 Oct 2002 15:46:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <87lm4nxxnj.fsf@ceramic.fifi.org>
References: <8800000.1035498319@w-hlinder>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <8800000.1035498319@w-hlinder>
List-Id: linux-scsi@vger.kernel.org
To: Hanna Linder <hannal@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, tmolina@cox.net, haveblue@us.ibm.com

Hanna Linder <hannal@us.ibm.com> writes:

> >                                2.5 Kernel Problem Reports as of 22 Oct
> >    Status                 Discussion  Problem Title
> > 
> >    open                   04 Oct 2002 AIC7XXX boot failure
> >    1. http://marc.theaimsgroup.com/?l=linux-kernel&m=103356254615324&w=2
> > 
> 
> 
> This may be a different problem but it is related to the aic7xxx
> driver. My system is a 2-way PIII 500MHz 2.5GB RAM box. It boots
> if I remove the aic7xxx driver. This is on 2.5.44 btw. Works fine
> on 2.4.x.

What error do you get on boot?

Have you tried booting with "noapic"?

Phil.
