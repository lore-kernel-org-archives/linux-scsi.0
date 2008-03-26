From: Marc Bejarano <beej@alum.mit.edu>
Subject: Re: data corruption: ext3/lvm2/md/mptsas/vitesse/seagate
Date: Tue, 25 Mar 2008 22:17:39 -0400
Message-ID: <200803260217.m2Q2HsiU023202@colby.verdasys.com>
References: <200803062108.m26L8e4i020882@colby.verdasys.com>
 <1204848652.3062.100.camel@localhost.localdomain>
 <200803101519.m2AFJCJS032509@colby.verdasys.com>
 <1205163386.2941.14.camel@localhost.localdomain>
 <7.1.0.9.2.20080311174743.1376cc30@alum.mit.edu>
 <200803252343.m2PNh8kl020506@colby.verdasys.com>
 <da824cf30803251712t801fdaexc19ba4fe8130ee2e@mail.gmail.com> <da824cf30803251712t801fdaexc19ba4fe8130ee2e@mail.gmail.com
 >
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <da824cf30803251712t801fdaexc19ba4fe8130ee2e@mail.gmail.com
 >
References: <200803062108.m26L8e4i020882@colby.verdasys.com>
 <1204848652.3062.100.camel@localhost.localdomain>
 <200803101519.m2AFJCJS032509@colby.verdasys.com>
 <1205163386.2941.14.camel@localhost.localdomain>
 <7.1.0.9.2.20080311174743.1376cc30@alum.mit.edu>
 <200803252343.m2PNh8kl020506@colby.verdasys.com>
 <da824cf30803251712t801fdaexc19ba4fe8130ee2e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

At 20:12 3/25/2008, Grant Grundler wrote:
 >On Tue, Mar 25, 2008 at 4:43 PM, Marc Bejarano <beej@alum.mit.edu> wrote:
 >>  having never played with blocktrace, i have no idea what it's
 >>  capabilities are.  can it be used to record not just the IOs, but
 >>  also their timings?  any other ideas?  i'm at a loss for how to turn
 >>  my reproducible test case into something i can send to seagate for
 >>  investigation.
 >
 >Yes and yes (I think). But by itself, it won't help since block
 >trace tools don't generally do any data validation.

we've been successfully using md's mirror consistency-checking 
capabilities to spot the corruption.  if we can get an IO pattern 
that reproduces the issue, we're golden.  if only we didn't other 
things to do with our time that were actually productive for us 
;)  hopefully we'll be able to report back soon-ish with more.

if anybody else has helpful ideas, we're all ears.

thanks, grant!

marc

