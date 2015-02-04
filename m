From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v3 1/9] vhost/scsi: Convert completion path to use
 copy_to_iser
Date: Wed, 04 Feb 2015 00:47:02 -0800
Message-ID: <1423039622.28700.1.camel@haakon3.risingtidesystems.com>
References: <1422945003-24538-1-git-send-email-nab@daterainc.com>
	 <1422945003-24538-2-git-send-email-nab@daterainc.com>
	 <20150203092405.GH2830@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150203092405.GH2830@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-02-03 at 11:24 +0200, Michael S. Tsirkin wrote:
> 
> On Tue, Feb 03, 2015 at 06:29:55AM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Required for ANY_LAYOUT support when the incoming virtio-scsi response
> > header + fixed size sense buffer payload may span more than a single
> > iovec entry.
> > 
> > This changes existing code to save cmd->tvc_resp_iov instead of the
> > first single iovec base pointer from &vq->iov[out].
> 
> Typo in subject: should be copy_to_iter.

Fixed.

> 
> > v3 changes:
> >   - Convert memcpy_toiovecend -> copy_to_iser usage
> 
> This belongs after ---
> 

Dropping these from the -v4 commits..

--nab


