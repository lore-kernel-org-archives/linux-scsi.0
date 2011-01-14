From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: training mpath to discern between SCSI errors
Date: Fri, 14 Jan 2011 08:59:17 -0500
Message-ID: <20110114135917.GA25506@redhat.com>
References: <4C7BA670.2060303@suse.de>
 <4C7BC5B4.3010707@suse.de>
 <4CBC00B3.7090603@ce.jp.nec.com>
 <4CBC35AE.9050002@suse.de>
 <20101119031149.GA28455@us.ibm.com>
 <20101130225956.GA8882@redhat.com>
 <4D0B31B5.101@suse.de>
 <20101217140605.GA740@redhat.com>
 <20110114010948.GA21818@redhat.com>
 <4D2FFF00.8020702@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D2FFF00.8020702@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, michaelc@cs.wisc.edu, tytso@mit.edu, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, vst@vlnb.net, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, James.Bottomley@suse.de, Sergei Shtylyov <sshtylyov@mvista.com>, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, jack@suse.cz, rwheeler@redhat.com, swhiteho@redhat.com, chris.mason@oracle.com, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 14 2011 at  2:45am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 01/14/2011 02:09 AM, Mike Snitzer wrote:
> > On Fri, Dec 17 2010 at  9:06am -0500,
> > Mike Snitzer <snitzer@redhat.com> wrote:
> > 
> >> On Fri, Dec 17 2010 at  4:47am -0500,
> >> Hannes Reinecke <hare@suse.de> wrote:
> >>
> >>> On 11/30/2010 11:59 PM, Mike Snitzer wrote:
> >>>> Hannes,
> >>>>
> >>>> Any chance you've had time to fold your proposed logging changes in and
> >>>> rebase this patch?  Could you post that updated patch?
> >>>>
> >>> yes, will be following shortly.
> >>>
> >>>> I'd like to help see this patch through to inclussion when 2.6.38 merge
> >>>> window opens.  I can help with further review, testing and development.
> >>>>
> >>> Ok, thanks.
> >>
> >> I took some steps at furthering your work.  Here is the cover letter to
> >> the patches I resently sent to dm-devel:
> >> https://www.redhat.com/archives/dm-devel/2010-December/msg00090.html
> >>
> >> And here are the patches:
> >> https://patchwork.kernel.org/patch/384612/
> >> https://patchwork.kernel.org/patch/384602/
> >> https://patchwork.kernel.org/patch/390882/
> >>
> >> Please feel free to change these how ever you see fit but your feedback
> >> is really appreciated.
> > 
> > Hannes,
> > 
> > Any update?  I'd really like to see this work get upstream ASAP.  I'm
> > doubtful that is possible for 2.6.38 given the merge window is likely to
> > close shortly.
> > 
> Sorry for the late answer; the above patches somehow got lost in my
> various mail folders :-(
> 
> But yes, the patchset looks okay.
> Feel free to add my Acked-by: to last two.

OK.

> > Regardless, if we could get consensus on this work now and then stage it
> > with James that would be great.
> > 
> Indeed. Will you resend it to linux-scsi or shall I do it?

I can resend, will do so shortly.

Thanks!
Mike
