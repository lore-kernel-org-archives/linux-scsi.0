From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] [ATTEND] Storage management (API &
 Library)
Date: Tue, 24 Jan 2012 12:44:31 -0600
Message-ID: <1327430671.2894.63.camel@dabdike>
References: <4F19A981.4080502@redhat.com>
	 <1327157825.2748.5.camel@dabdike.int.hansenpartnership.com>
	 <4F1D8913.1060709@redhat.com> <1327423944.2894.45.camel@dabdike>
	 <4F1EF463.6030800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36701 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752699Ab2AXSog (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2012 13:44:36 -0500
In-Reply-To: <4F1EF463.6030800@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: tasleson@redhat.com, lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On Tue, 2012-01-24 at 13:11 -0500, Ric Wheeler wrote:
> On 01/24/2012 11:52 AM, James Bottomley wrote:
> > On Mon, 2012-01-23 at 10:21 -0600, Tony Asleson wrote:
> >> On 01/21/2012 08:57 AM, James Bottomley wrote:
> >>> It's also a bit insular ... the first thing you usually ask in open
> >>> source is what can I steal^Wborrow from other projects and how do I
> >>> recruit others to do the work for me.
> >> The project site is a little sparse on details about what we have looked
> >> at and considered.  Ric Wheeler covered some of this during his
> >> presentation in Prague, but I will place more information on the project
> >> web site.
> > That would be good for those who didn't go to that presentation ...
> >
> >>> The first question is probably: is there anything we can liberate
> >>> from the Oracle storage API fisasco to help with this.
> >> The Oracle storage connect library was evaluated and subsequently
> >> rejected for the following reasons:
> >>
> >> 1. The Oracle storage connect library is dual licensed, GPL and a
> >> proprietary Oracle license which allows proprietary use.  This allows
> >> hardware vendors the ability to write proprietary plug-ins.  The design
> >> of the library has the library user and plug-in executing in the same
> >> address space.  Based on the information presented on plug-ins
> >> (http://www.gnu.org/licenses/gpl-faq.html#GPLAndPlugins) this design
> >> goes against the requirements of GPL license compliance.  Proprietary
> >> plug-ins could be in compliance if they are implemented to execute in a
> >> separate process.
> > This is actually wrong thinking.  Almost every Open Source project has
> > an incompatible licence.  The way we work around this (once we've
> > determined there's something worth stealing) is to ask the project owner
> > for a compatible grant (in this case, some pieces under LGPL).  That's
> > how we share driver code between Linux and BSD for instance.
> >
> > If Oracle is intent on pursuing an open core business model for this and
> > says "no" to the request, then you can say they're incompatible ... did
> > anyone ask them?
> 
> I think that ignores the history behind the Oracle storage management project. 
> We did look at the Oracle work, it certainly has been a long time coming and was 
> not done in a community fashion as far as I can tell.

I'm not denying it's been a royal screw up ... particularly with the
"sure we're releasing it any day now" message we got for two years.  But
that is partly due to the fact that the open source guy left the project
a while back.

> Putting the burden back on you, can you point to a single post about their 
> project on a community list or name an individual (still employed by Oracle) 
> that we can discuss with :) ?

Um, that question is rhetorical, right?  Or are you implying Martin
Petersen is no longer at oracle (which will come as news to him, I
think)?

> We waited years for them to get to the dual license decision in the first place.
> 
> Having looked at their code, I think it is easier to write it - in a community 
> way - the way we would have it done than to spend another year waiting on their 
> legal team to change the license.

However annoyed we might be with Oracle, reinventing an existing project
that already has committed vendor plugin contributors and thus forcing
vendors to choose which project to support isn't going to be hugely
helpful.  Assuming the worst about Oracle, what's the barriers to
reusing the plugins (the API is public and doesn't have a licensing
issue)?

> Clearly, using GPL for a library (not LGPL) is meant to push people into the 
> commercial license....

You're assuming a malign motive where there could be simple open source
ignorance.  I'll dig around and see if I can get a read on what they're
actually up to.

James


