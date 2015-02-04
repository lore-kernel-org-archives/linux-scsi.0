From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v3 7/9] vhost/scsi: Drop legacy pre virtio v1.0
 !ANY_LAYOUT logic
Date: Wed, 04 Feb 2015 01:03:48 -0800
Message-ID: <1423040628.28700.13.camel@haakon3.risingtidesystems.com>
References: <1422945003-24538-1-git-send-email-nab@daterainc.com>
	 <1422945003-24538-8-git-send-email-nab@daterainc.com>
	 <20150203093725.GK2830@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150203093725.GK2830@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-02-03 at 11:37 +0200, Michael S. Tsirkin wrote:
> On Tue, Feb 03, 2015 at 06:30:01AM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > With the new ANY_LAYOUT logic in place for vhost_scsi_handle_vqal(),
> > there is no longer a reason to keep around the legacy code with
> > !ANY_LAYOUT assumptions.
> > 
> > Go ahead and drop the pre virtio 1.0 logic in vhost_scsi_handle_vq()
> > and associated helpers.
> 
> Will probably be easier to review if you smash this with patch 5,
> this way we see both old and new code side by side.
> 

So was thinking it might be useful to leave this as a separate patch,
just in case !ANY_LAYOUT needs to be resurrected for some reason, so
both modes can function.

But at this point I really don't see a case why that would be
necessary..

> Also, let's rename _vqal to _vq in this patch?

Merging this patch into 7, changing name to _vq.

--nab

