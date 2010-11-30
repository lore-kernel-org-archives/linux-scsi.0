From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: training mpath to discern between SCSI errors
Date: Tue, 30 Nov 2010 17:59:56 -0500
Message-ID: <20101130225956.GA8882@redhat.com>
References: <20100825155918.GB8509@redhat.com>
 <4C7B984E.4070802@suse.de>
 <4C7B9F14.9080900@mvista.com>
 <4C7BA670.2060303@suse.de>
 <4C7BC5B4.3010707@suse.de>
 <4CBC00B3.7090603@ce.jp.nec.com>
 <4CBC35AE.9050002@suse.de>
 <20101119031149.GA28455@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101119031149.GA28455@us.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, michaelc@cs.wisc.edu, tytso@mit.edu, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, vst@vlnb.net, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, James.Bottomley@suse.de, Sergei Shtylyov <sshtylyov@mvista.com>, konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org, jack@suse.cz, rwheeler@redhat.com, swhiteho@redhat.com, chris.mason@oracle.com, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 18 2010 at 10:11pm -0500,
Malahal Naineni <malahal@us.ibm.com> wrote:

> Hannes Reinecke [hare@suse.de] wrote:
> > > Also (although this might be a bit off topic from your patch),
> > > can we expand such a distinction to what should be logged?
> > > Currently, it's difficult to distinguish important SCSI/block errors
> > > and less important ones in kernel log.
> > > For example, when I get a link failure on sda, kernel prints something
> > > like below, regardless of whether the I/O is recovered by multipathing or not:
> > >   end_request: I/O error, dev sda, sector XXXXX
> > > 
> > Indeed, when using the above we could be modifying the above
> > message, eg by
> > 
> > end_request: transport error, dev sda, sector XXXXX
> > 
> > or
> > 
> > end_request: target error, dev sda, sector XXXXX
> > 
> > which would improve the output noticeable.
> > 
> > > Setting REQ_QUIET in dm-multipath could mask the message
> > > but also other important ones in SCSI.
> > > 
> > Hmm. Not sure about that, but I think the above modifications will
> > be useful already.
> > 
> > I'll be sending an updated patch.
> 
> Hannes, is there an updated version of this patch? It applied fine with
> Linus git tree with a minor reject! I would like to test an updated
> version if you have one (the update seems to refer to better logging
> only, right?).

Hannes,

Any chance you've had time to fold your proposed logging changes in and
rebase this patch?  Could you post that updated patch?

I'd like to help see this patch through to inclussion when 2.6.38 merge
window opens.  I can help with further review, testing and development.

Please advise, thanks.
Mike
