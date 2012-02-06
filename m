From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v3] Add virtio-scsi to the virtio spec
Date: Tue, 07 Feb 2012 10:06:04 +1030
Message-ID: <87ehu7ilgb.fsf@rustcorp.com.au>
References: <1328439694-18705-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:48299 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034Ab2BGAaM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2012 19:30:12 -0500
In-Reply-To: <1328439694-18705-1-git-send-email-pbonzini@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, virtualization <virtualization@lists.linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Sun,  5 Feb 2012 12:01:34 +0100, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Hi Rusty,
> 
> here is the specification for a virtio-based SCSI host (controller, HBA,
> you name it) so that you can apply it to the spec document and publish it.
> 
> I changed the index from 7 to 8 to account for the rpmsg device,
> and added a feature bit to tell the guest in advance whether the host
> supports hotplug.  Otherwise there is no change from v2.
> 
> Paolo

Thanks, applied!

I will release a new draft version shortly.

Cheers,
Rusty.
