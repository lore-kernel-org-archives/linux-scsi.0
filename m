From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH v2 1/5] virtio: add functions for piecewise addition of
 buffers
Date: Wed, 19 Dec 2012 11:47:22 +0100
Message-ID: <20121219104722.GA5832@stefanha-thinkpad.redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
 <1355833972-20319-2-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1355833972-20319-2-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gaowanlong@cn.fujitsu.com, hutao@cn.fujitsu.com, linux-scsi@vger.kernel.org, virtualization@lists.linux-foundation.org, mst@redhat.com, rusty@rustcorp.com.au, asias@redhat.com, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 18, 2012 at 01:32:48PM +0100, Paolo Bonzini wrote:
> +/**
> + * virtqueue_start_buf - start building buffer for the other end
> + * @vq: the struct virtqueue we're talking about.
> + * @buf: a struct keeping the state of the buffer
> + * @data: the token identifying the buffer.
> + * @count: the number of buffers that will be added

Perhaps count should be named count_bufs or num_bufs.

> + * @count_sg: the number of sg lists that will be added

What is the purpose of count_sg?

Stefan
