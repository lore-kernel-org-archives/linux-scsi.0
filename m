From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Xen-devel] [PATCH V2 3/4] Introduce XEN scsiback module
Date: Tue, 29 Jul 2014 05:28:07 -0700
Message-ID: <20140729122807.GA15127@infradead.org>
References: <1406288253-13293-1-git-send-email-jgross@suse.com>
 <1406288253-13293-4-git-send-email-jgross@suse.com>
 <20140726152358.GA1854@infradead.org>
 <53D5C506.7070505@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53D5C506.7070505@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: J?rgen Gro? <jgross@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, target-devel@vger.kernel.org, JBottomley@parallels.com, linux-scsi@vger.kernel.org, xen-devel@lists.xen.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 28, 2014 at 05:35:34AM +0200, J?rgen Gro? wrote:
> On 07/26/2014 05:23 PM, Christoph Hellwig wrote:
> >Just a quick glance:
> >
> >  a) this should move to drivers/target with the other target code
> 
> I don't mind. I just followed the example of drivers/vhost/vhost.c and
> thought the similar xen module should be located under drivers/xen.

Oh sorry, I overlooked that you moved it to drivers/xen from drivers/scsi in
the initial submission.  That's fine with me.

> >  b) you're still having your own CDB emulation in there, the target code
> >     should be taking care of all that.
> 
> Okay, I'll remove the CDB emulation.

Thanks.  If there's anything missing that Xen except feel free to adopt
the target core to it.
