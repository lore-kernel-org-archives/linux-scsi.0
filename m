From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH-v3 6/9] vhost/scsi: Set VIRTIO_F_ANY_LAYOUT +
 VIRTIO_F_VERSION_1 feature bits
Date: Wed, 4 Feb 2015 10:34:09 +0100
Message-ID: <20150204093409.GG9920@redhat.com>
References: <1422945003-24538-1-git-send-email-nab@daterainc.com>
 <1422945003-24538-7-git-send-email-nab@daterainc.com>
 <20150203094058.GN2830@redhat.com>
 <1423041238.28700.18.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933534AbbBDJeY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Feb 2015 04:34:24 -0500
Content-Disposition: inline
In-Reply-To: <1423041238.28700.18.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>, cornelia.huck@de.ibm.com

On Wed, Feb 04, 2015 at 01:13:58AM -0800, Nicholas A. Bellinger wrote:
> On Tue, 2015-02-03 at 11:40 +0200, Michael S. Tsirkin wrote:
> > On Tue, Feb 03, 2015 at 06:30:00AM +0000, Nicholas A. Bellinger wrote:
> > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > > 
> > > Signal support of VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits
> > > required for virtio-scsi 1.0 spec layout requirements.
> > > 
> > > Cc: Michael S. Tsirkin <mst@redhat.com>
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > 
> > I'm hoping someone'll actually test this with a BE guest before
> > we release this though.
> > 
> 
> Yes please.  Currently waiting on an Power system to test against, but
> alas all of the OP systems are LE these days..
> 
> What's left, s390..?  ;)
> 
> --nab

Yes - Cc Conelia, I think she was interested in that.

-- 
MST
