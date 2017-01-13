From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] multipath redesign
Date: Fri, 13 Jan 2017 18:41:52 +0100
Message-ID: <fb08f4f6-5bb0-9014-c799-6c39c20d0219@suse.de>
References: <00700606-3005-c82b-ee37-127417fbd201@suse.de>
 <20170111222339.GC19051@redhat.com>
 <19415684-1ec7-1926-b420-3b53ea247e1b@suse.de>
 <20170112172959.GT2732@octiron.msp.redhat.com>
 <def3ef1e-1a81-aab1-7fa8-ade1ebeaa0d5@suse.de>
 <20170113160733.GA30128@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170113160733.GA30128@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 01/13/2017 05:07 PM, Mike Snitzer wrote:
> On Fri, Jan 13 2017 at 10:56am -0500,
> Hannes Reinecke <hare@suse.de> wrote:
> 
>> On 01/12/2017 06:29 PM, Benjamin Marzinski wrote:
[ .. ]
>>> While I've daydreamed of rewriting the multipath tools multiple times,
>>> and having nothing aginst you doing it in concept, I would be happier
>>> knowing that it won't simply mean that there are two sets of tools, that
>>> both need to be supported to deal with all customer configurations.
>>>
>> Sure. I feel the pain of supporting multipath-tools all too strongly.
>> Having two tools for the same thing is always a pain, and I would like
>> to avoid this if at all possible.
> 
> I welcome your work.  Should help us focus on what fat needs to be
> trimmed from both multipath-tools and kernel.
> 
> Might be a good time to branch multipath-tools and get very aggressive
> with trimming stuff that is outdated.
> 
> Things like the event stuff, using select interface, that Andy Grover is
> working on (and Mikulas is taking a stab at finishing/optimizing) is
> something that might help... but your approach described in this thread
> may prove better.
> 
> Point is, everything should be on the table for revitalizing multipath
> userspace (and kernel) to meet new requirements (e.g. NVMEoF, etc).
> 
> And yes, I'd prefer to ultimately see these advances land in terms of DM
> multipath advances but we'll take it as it comes.

I'm fully on board with that.
And it would be good if Ben Marzinski would be present, too;
he might have some insights which both of us might lack
(like the ominous dm-event interface into multipathd where we both
struggle to figure out what it's for ...)

Looking forward to that discussion.
And promising to have some results by then.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
