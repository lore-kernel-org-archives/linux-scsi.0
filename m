From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v3 4/9] vhost/scsi: Add ANY_LAYOUT iov -> sgl mapping
 prerequisites
Date: Wed, 04 Feb 2015 00:48:40 -0800
Message-ID: <1423039720.28700.2.camel@haakon3.risingtidesystems.com>
References: <1422945003-24538-1-git-send-email-nab@daterainc.com>
	 <1422945003-24538-5-git-send-email-nab@daterainc.com>
	 <20150203093222.GI2830@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:46899 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbbBDIsn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Feb 2015 03:48:43 -0500
In-Reply-To: <20150203093222.GI2830@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>

On Tue, 2015-02-03 at 11:32 +0200, Michael S. Tsirkin wrote:
> On Tue, Feb 03, 2015 at 06:29:58AM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch adds ANY_LAYOUT prerequisites logic for accepting a set of
> > protection + data payloads via iov_iter.  Also includes helpers for
> > calcuating SGLs + invoking vhost_scsi_map_to_sgl() with a known number
> > of iovecs.
> > 
> > Required by ANY_LAYOUT processing when struct iovec may be offset into
> > the first outgoing virtio-scsi request header.
> > 
> > v2 changes:
> >   - Clear ->tvc_sgl_count for vhost_scsi_mapal failure
> >   - Make vhost_scsi_mapal + vhost_scsi_calc_sgls accept max_niov
> >   - Minor cleanups
> > 
> > v3 changes:
> >   - Update vhost_scsi_mapal + friends to use iov_iter
> >   - Move iov_iter sanity checks into vhost_scsi_calc_sgls
> >   - Convert vhost_scsi_calc_sgls() to iov_iter_npages()
> 
> I guess if this goes through your tree, you can drop these
> when applying, but it's best not to assume this, and put
> changelog after ---.
> 

Dropped as well..

--nab

