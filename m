From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Pe: [PATCH v5 1/3] virtio-scsi: first version
Date: Sun, 12 Feb 2012 14:16:17 -0600
Message-ID: <1329077777.21613.60.camel@dabdike.int.hansenpartnership.com>
References: <OF2D939B55.7C07E33B-ONC125799C.0032B83A-C125799C.0036282C@de.ibm.com>
	 <4F30F4EE.4080607@redhat.com> <4F311154.9080407@de.ibm.com>
	 <4F3119A0.7080005@redhat.com> <4F312492.1040002@de.ibm.com>
	 <OFAFB86CAE.9917478D-ONC125799D.004AF231-C125799D.004CE6D2@de.ibm.com>
	 <4F313526.2050907@redhat.com>
	 <OF36197712.1A42EB9E-ONC125799E.0049E3C2-C125799E.004AD4BF@de.ibm.com>
	 <4F3390FB.80107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33610 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753929Ab2BLUQV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Feb 2012 15:16:21 -0500
In-Reply-To: <4F3390FB.80107@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christian Hoff <christian.hoff@de.ibm.com>, BORNTRAE@linux.vnet.ibm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com, rusty@rustcorp.com.au

On Thu, 2012-02-09 at 10:25 +0100, Paolo Bonzini wrote:
> On 02/08/2012 02:37 PM, Christian Hoff wrote:
> > Again, I have already done much testing with virtio-scsi and can confirm
> > that the code is working flawlessly. In my opinion, virtio-scsi is a
> > worthwhile addition to virtio-block and should be considered for inclusion
> > into mainline kernel code.
> 
> Thank you very much!
> 
> James, will you include virtio-scsi in 3.4?

Well, no-one's yet answered the question I had about why.  virtio-scsi
seems to be a basic duplication of virtio-blk except that it seems to
fix some problems virtio-blk has.  Namely queue parameter discover,
which virtio-blk doesn't seem to do.  There may also be a reason to cut
the stack lower down.  Error handling is most often cited for this, but
no-one's satisfactorily explaned why it's better to do error handling in
the guest instead of the host.

Could someone please explain to me why you can't simply fix virtio-blk?
Or would virtio-blk maintainers give a reason why they're unwilling to
have it fixed?

This isn't a "no" by the way: we have absolutely hideous virtual drivers
for other virtualisation systems in SCSI which should also have been in
block, except that's not the way the various virt people think, so I'm
willing to extend KVM the same courtesy ... I'd just really like to know
that the virtio-blk situation is intractable before I do.

James


