From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 3/3] block: add back command filter modification via
 sysfs
Date: Wed, 12 Sep 2012 13:38:49 +0100
Message-ID: <20120912133849.6bec96be@pyramind.ukuu.org.uk>
References: <1347449133-26476-1-git-send-email-pbonzini@redhat.com>
	<1347449133-26476-4-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1347449133-26476-4-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

O
> +	if (!q->cmd_filter) {
> +		q->cmd_filter = kmalloc(sizeof(struct blk_cmd_filter),
> +					GFP_KERNEL);
> +		blk_set_cmd_filter_defaults(q->cmd_filter);

Out of memory - memset - oops
