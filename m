From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] [ATTEND] Storage management (API & Library)
Date: Tue, 24 Jan 2012 13:11:47 -0500
Message-ID: <4F1EF463.6030800@gmail.com>
References: <4F19A981.4080502@redhat.com>  <1327157825.2748.5.camel@dabdike.int.hansenpartnership.com>  <4F1D8913.1060709@redhat.com> <1327423944.2894.45.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53825 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab2AXSLx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2012 13:11:53 -0500
Received: by ggnb1 with SMTP id b1so2117311ggn.19
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2012 10:11:53 -0800 (PST)
In-Reply-To: <1327423944.2894.45.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: tasleson@redhat.com, lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On 01/24/2012 11:52 AM, James Bottomley wrote:
> On Mon, 2012-01-23 at 10:21 -0600, Tony Asleson wrote:
>> On 01/21/2012 08:57 AM, James Bottomley wrote:
>>> It's also a bit insular ... the first thing you usually ask in open
>>> source is what can I steal^Wborrow from other projects and how do I
>>> recruit others to do the work for me.
>> The project site is a little sparse on details about what we have looked
>> at and considered.  Ric Wheeler covered some of this during his
>> presentation in Prague, but I will place more information on the project
>> web site.
> That would be good for those who didn't go to that presentation ...
>
>>> The first question is probably: is there anything we can liberate
>>> from the Oracle storage API fisasco to help with this.
>> The Oracle storage connect library was evaluated and subsequently
>> rejected for the following reasons:
>>
>> 1. The Oracle storage connect library is dual licensed, GPL and a
>> proprietary Oracle license which allows proprietary use.  This allows
>> hardware vendors the ability to write proprietary plug-ins.  The design
>> of the library has the library user and plug-in executing in the same
>> address space.  Based on the information presented on plug-ins
>> (http://www.gnu.org/licenses/gpl-faq.html#GPLAndPlugins) this design
>> goes against the requirements of GPL license compliance.  Proprietary
>> plug-ins could be in compliance if they are implemented to execute in a
>> separate process.
> This is actually wrong thinking.  Almost every Open Source project has
> an incompatible licence.  The way we work around this (once we've
> determined there's something worth stealing) is to ask the project owner
> for a compatible grant (in this case, some pieces under LGPL).  That's
> how we share driver code between Linux and BSD for instance.
>
> If Oracle is intent on pursuing an open core business model for this and
> says "no" to the request, then you can say they're incompatible ... did
> anyone ask them?

I think that ignores the history behind the Oracle storage management project. 
We did look at the Oracle work, it certainly has been a long time coming and was 
not done in a community fashion as far as I can tell.

Putting the burden back on you, can you point to a single post about their 
project on a community list or name an individual (still employed by Oracle) 
that we can discuss with :) ?

We waited years for them to get to the dual license decision in the first place.

Having looked at their code, I think it is easier to write it - in a community 
way - the way we would have it done than to spend another year waiting on their 
legal team to change the license.

Clearly, using GPL for a library (not LGPL) is meant to push people into the 
commercial license....

Ric



>> 2. At the time the Oracle storage connect library was being evaluated we
>> were unable to obtain a plug-in from a few different vendors.  Without
>> plug-ins the value of any library becomes greatly diminished.
> Why?  You have no plug ins for your project currently ... that doesn't
> really diminish the value of it as an emerging project.
>
> It sounds like you evaluated the Oracle project from an all or nothing
> standpoint rather than a what can we learn/steal standpoint.
>
> One of the big things we could co-opt from oracle looks to be vendor buy
> in (they seem to be investing more in marketing than actual
> engineering).  Vendors hate being confused or making choices, so one
> easy way to bring them on board might be API compatibility with the
> Oracle project.
>
>>> The second might be what would it take to get vendors interested in
>>> doing the array plugin glue.
>> By providing:
>> * Permissive license (LGPL)
>> * Easy to use out of process plug-in support to allow proprietary
>> plug-ins (IPC is abstracted)
>> * Language agnostic plug-in support (initial support is C and python)
>>
>> We are hoping we can get hardware vendors interested in providing their
>> own plug-ins.  If anyone has additional ideas, we would certainly like
>> to discuss them.
> So no actual vendors have provided any input yet?
>
> James
>

