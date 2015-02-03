From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/8] vhost/scsi: Add ANY_LAYOUT support
Date: Mon, 02 Feb 2015 16:22:43 -0800
Message-ID: <1422922963.24128.4.camel@haakon3.risingtidesystems.com>
References: <1422605552-24797-1-git-send-email-nab@daterainc.com>
	 <20150202081525.GA7264@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150202081525.GA7264@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2015-02-02 at 00:15 -0800, Christoph Hellwig wrote:
> Hi Nic,
> 
> Al has been rewriting the vhost code to use iov_iter primitives,
> can you please rebase it on top of that istead of using the obsolete
> infrastructure?
> 

Yep, already done with the copy_[from,to]_iter() conversion in
vhost_scsi_handle_vqal() + vhost_scsi_complete_cmd_work() respectively.

Looking at iov_iter_get_pages() now to see if it can replace the other
code, or if that should be a post merge improvement instead.

--nab
