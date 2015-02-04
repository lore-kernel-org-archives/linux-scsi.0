From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v3 6/9] vhost/scsi: Set VIRTIO_F_ANY_LAYOUT +
 VIRTIO_F_VERSION_1 feature bits
Date: Wed, 04 Feb 2015 01:13:58 -0800
Message-ID: <1423041238.28700.18.camel@haakon3.risingtidesystems.com>
References: <1422945003-24538-1-git-send-email-nab@daterainc.com>
	 <1422945003-24538-7-git-send-email-nab@daterainc.com>
	 <20150203094058.GN2830@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150203094058.GN2830@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-02-03 at 11:40 +0200, Michael S. Tsirkin wrote:
> On Tue, Feb 03, 2015 at 06:30:00AM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Signal support of VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits
> > required for virtio-scsi 1.0 spec layout requirements.
> > 
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> I'm hoping someone'll actually test this with a BE guest before
> we release this though.
> 

Yes please.  Currently waiting on an Power system to test against, but
alas all of the OP systems are LE these days..

What's left, s390..?  ;)

--nab

