From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] storvsc: do not assume SG list is continuous when doing
 bounce buffers (for 4.1 stable only)
Date: Wed, 23 Aug 2017 06:41:00 -0700
Message-ID: <20170823134100.GC31113@kroah.com>
References: <1503379905-18908-1-git-send-email-longli@exchange.microsoft.com>
 <20170822062841.GA1061@infradead.org>
 <MWHPR21MB0190D1C8C3FAF25AE283ABCFCE840@MWHPR21MB0190.namprd21.prod.outlook.com>
 <20170823064319.GA19373@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170823064319.GA19373@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 22, 2017 at 11:43:19PM -0700, Christoph Hellwig wrote:
> Ok.  If the stable maintainers are ok with your small fix
> I'm not going to complain too loudly.  But I'm always worried about
> stable trees divering too much from mainline.

Given that 90% of the time we do this, something breaks, you have a
right to be worried...
