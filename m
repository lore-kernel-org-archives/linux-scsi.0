From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] storvsc: do not assume SG list is continuous when doing
 bounce buffers (for 4.1 stable only)
Date: Mon, 21 Aug 2017 23:28:41 -0700
Message-ID: <20170822062841.GA1061@infradead.org>
References: <1503379905-18908-1-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1503379905-18908-1-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Long Li <longli@exchange.microsoft.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <JBottomley@odin.com>, devel@linuxdriverproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Long Li <longli@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Wouldn't it make sense to backport the changes to set the virt_boundary
(which probably still is the SG_GAPS flag in such an old kernel)?
