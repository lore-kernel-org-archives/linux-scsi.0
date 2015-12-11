From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCHv4 1/1] SCSI: hosts: update to use ida_simple for
 host_no management
Date: Fri, 11 Dec 2015 10:31:51 -0500
Message-ID: <1449847911.4067.200.camel@localhost.localdomain>
References: <cover.1444241058.git.lduncan@suse.com>
	 <f89fe3933ae899dc01f2eddd2a0cefac3383cf3c.1444241058.git.lduncan@suse.com>
	 <1444830904.2220.28.camel@HansenPartnership.com>
	 <561EA018.7020700@suse.com>
	 <1444848835.2220.50.camel@HansenPartnership.com>
	 <5644BEE1.3010208@suse.com> <yq1ziyhy38c.fsf@sermon.lab.mkp.net>
	 <5649C79E.9070603@suse.de> <564A4EDC.8060805@suse.com>
	 <yq1d1v8tdr3.fsf@sermon.lab.mkp.net>  <5669F31C.2010409@suse.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5669F31C.2010409@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-12-10 at 13:48 -0800, Lee Duncan wrote:
> On 11/17/2015 03:20 PM, Martin K. Petersen wrote:
> >>>>>> "Lee" == Lee Duncan <lduncan@suse.com> writes:
> > 
> > Lee> Martin: I will be glad to update the patch, creating a modprobe
> > Lee> parameter as suggested, if you find this acceptable.
> > 
> > For development use a module parameter would be fine. But I am concerned
> > about our support folks that rely on the incrementing host number when
> > analyzing customer log files.
> > 
> > Ewan: How do you folks feel about this change?
> > 
> 
> Ewan?


Personally, I think having host numbers that increase essentially
without limit (I think I've seen this with iSCSI sessions) are a
problem, the numbers start to lose meaning for people when they
are not easily recognizable.  Yes, it can help when you're analyzing
a log file, but it seems to me that you would want to track the
host state throughout anyway, so you could just follow the number
as it changes.

If we change the behavior, we have to change documentation, and
our support people will get calls.  But that's not a reason not
to do it.

-Ewan
