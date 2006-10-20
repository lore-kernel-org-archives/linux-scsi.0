From: Luben Tuikov <ltuikov@yahoo.com>
Subject: RE: Mid-layer API?
Date: Fri, 20 Oct 2006 10:25:49 -0700 (PDT)
Message-ID: <20061020172549.7666.qmail@web31812.mail.mud.yahoo.com>
References: <861B5CF71BC70C478DFEB9EAFE98F699ACA42C@G3W0068.americas.hpqcorp.net>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:1163 "HELO
	web31812.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S932208AbWJTRZu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 13:25:50 -0400
In-Reply-To: <861B5CF71BC70C478DFEB9EAFE98F699ACA42C@G3W0068.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Haefliger, Juerg" <Juerg.Haefliger@hp.com>, linux-scsi@vger.kernel.org

Juerg,

--- "Haefliger, Juerg" <Juerg.Haefliger@hp.com> wrote:
> > The answer to your question depends on the answer to this
> > question: Who is generating the commands and data, or loosely 
> > where are the commands and data coming from?
> 
> I'm using the Linux box as a 'dumb' SCSI adapter.

You just answered your question!

> The SCSI commands are
> received by a driver that manages a proprietary interface through which
> the commands are coming in from a remote host. The driver then needs to
> forward the commands to the FC disk (by means I'm trying to figure out
> here :-) and pass the results back up to the host.

You again answered your own question.
 
> I guess my biggest problem is that I don't fully understand the flow of
> command and data through the different layers.

Take a look at the scsi_host template, and the document Randy mentioned.

    Luben


> Not quiet there yet :-) 
> 
> Thanks for your help
> ...juerg
> 
> 
> > Good luck!
> >     Luben
> > 
> > 
> > > And finally, is there any
> > > documentation talking about the mid-layer API?
> > > 
> > > Any help is greatly appreciated.
> > > 
> > > Thanks
> > > ...juerg
> > > 
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe 
> > linux-scsi" 
> > > in the body of a message to majordomo@vger.kernel.org More 
> > majordomo 
> > > info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> > 
> 

