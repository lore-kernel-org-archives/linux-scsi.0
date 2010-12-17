From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: training mpath to discern between SCSI errors
Date: Fri, 17 Dec 2010 09:06:06 -0500
Message-ID: <20101217140605.GA740@redhat.com>
References: <20100825155918.GB8509@redhat.com> <4C7B984E.4070802@suse.de>
	<4C7B9F14.9080900@mvista.com> <4C7BA670.2060303@suse.de>
	<4C7BC5B4.3010707@suse.de> <4CBC00B3.7090603@ce.jp.nec.com>
	<4CBC35AE.9050002@suse.de> <20101119031149.GA28455@us.ibm.com>
	<20101130225956.GA8882@redhat.com> <4D0B31B5.101@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4D0B31B5.101@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, michaelc@cs.wisc.edu, tytso@mit.edu, Sergei Shtylyov <sshtylyov@mvista.com>, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, swhiteho@redhat.com, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, vst@vlnb.net, rwheeler@redhat.com, Christoph Hellwig <hch@lst.de>, chris.mason@oracle.com, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 17 2010 at  4:47am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 11/30/2010 11:59 PM, Mike Snitzer wrote:
> > Hannes,
> > 
> > Any chance you've had time to fold your proposed logging changes in and
> > rebase this patch?  Could you post that updated patch?
> > 
> yes, will be following shortly.
> 
> > I'd like to help see this patch through to inclussion when 2.6.38 merge
> > window opens.  I can help with further review, testing and development.
> > 
> Ok, thanks.

I took some steps at furthering your work.  Here is the cover letter to
the patches I resently sent to dm-devel:
https://www.redhat.com/archives/dm-devel/2010-December/msg00090.html

And here are the patches:
https://patchwork.kernel.org/patch/384612/
https://patchwork.kernel.org/patch/384602/
https://patchwork.kernel.org/patch/390882/

Please feel free to change these how ever you see fit but your feedback
is really appreciated.

Thanks,
Mike
