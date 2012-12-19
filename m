From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH v2 5/5] virtio-scsi: introduce multiqueue support
Date: Wed, 19 Dec 2012 12:27:18 +0100
Message-ID: <20121219112718.GB5832@stefanha-thinkpad.redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
 <1355833972-20319-6-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1355833972-20319-6-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gaowanlong@cn.fujitsu.com, hutao@cn.fujitsu.com, linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org, mst@redhat.com, rusty@rustcorp.com.au, asias@redhat.com, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 18, 2012 at 01:32:52PM +0100, Paolo Bonzini wrote:
>  struct virtio_scsi_target_state {
> -	/* Never held at the same time as vq_lock.  */
> +	/* This spinlock ever held at the same time as vq_lock.  */

s/ever/is never/
