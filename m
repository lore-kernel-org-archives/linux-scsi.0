From: Marc Bejarano <beej@alum.mit.edu>
Subject: Re: data corruption: ext3/lvm2/md/mptsas/vitesse/seagate
Date: Tue, 02 Sep 2008 15:32:39 -0400
Message-ID: <200809021932.m82JWfj3001152@colby.verdasys.com>
References: <200803062108.m26L8e4i020882@colby.verdasys.com>
 <1204848652.3062.100.camel@localhost.localdomain>
 <200803101519.m2AFJCJS032509@colby.verdasys.com>
 <1205163386.2941.14.camel@localhost.localdomain>
 <7.1.0.9.2.20080311174743.1376cc30@alum.mit.edu>
 <200803252343.m2PNh8kl020506@colby.verdasys.com>
 <da824cf30803251712t801fdaexc19ba4fe8130ee2e@mail.gmail.com>
 <200803260217.m2Q2HsiU023202@colby.verdasys.com>
 <da824cf30803261003i690f108dh86ff846e4f5fd2fa@mail.gmail.com>
 <7.1.0.9.2.20080327163522.14ab0ac8@alum.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7.1.0.9.2.20080327163522.14ab0ac8@alum.mit.edu>
References: <200803062108.m26L8e4i020882@colby.verdasys.com>
 <1204848652.3062.100.camel@localhost.localdomain>
 <200803101519.m2AFJCJS032509@colby.verdasys.com>
 <1205163386.2941.14.camel@localhost.localdomain>
 <7.1.0.9.2.20080311174743.1376cc30@alum.mit.edu>
 <200803252343.m2PNh8kl020506@colby.verdasys.com>
 <da824cf30803251712t801fdaexc19ba4fe8130ee2e@mail.gmail.com>
 <200803260217.m2Q2HsiU023202@colby.verdasys.com>
 <da824cf30803261003i690f108dh86ff846e4f5fd2fa@mail.gmail.com>
 <7.1.0.9.2.20080327163522.14ab0ac8@alum.mit.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Grant Grundler <grundler@google.com>
List-Id: linux-scsi@vger.kernel.org

At 16:45 3/27/2008, Marc Bejarano wrote:
 >unfortunately, we've already spent longer than we had.  the server
 >deployment is way overdue and our current plan is to just avoid
 >problematic drives and punt the problem to seagate.

i fought the good fight to try and get a seagate field application 
engineer to come on site to investigate or get them to reproduce the 
issue in their labs, but ultimately failed :(  at least seagate 
swapped some 70 problematic 7200.10's with equivalent 7200.11's and 
we haven't seen the presumed head placement issue with these.

i give up.  it's now somebody else's problem...

fwiw, since this nightmare began, we've been buying hitachis and have 
had much better luck wrt performance, failure rates, etc.

 >at least the next
 >time somebody sees similar issues with 3.AAJ and 3.AAK 7200.10's,
 >they'll know they aren't alone.

and if you have this problem, feel free to contact me at 781-228-5669 
and i'll put you in touch with the folks at seagate that it took me 
forever to get to.  hopefully you'll have better luck getting the 
dinosaur to react.

cheers,
marc

