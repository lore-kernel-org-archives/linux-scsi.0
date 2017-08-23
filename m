From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] storvsc: do not assume SG list is continuous when doing
 bounce buffers (for 4.1 stable only)
Date: Tue, 22 Aug 2017 23:43:19 -0700
Message-ID: <20170823064319.GA19373@infradead.org>
References: <1503379905-18908-1-git-send-email-longli@exchange.microsoft.com>
 <20170822062841.GA1061@infradead.org>
 <MWHPR21MB0190D1C8C3FAF25AE283ABCFCE840@MWHPR21MB0190.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <MWHPR21MB0190D1C8C3FAF25AE283ABCFCE840@MWHPR21MB0190.namprd21.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: Long Li <longli@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>, KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Ok.  If the stable maintainers are ok with your small fix
I'm not going to complain too loudly.  But I'm always worried about
stable trees divering too much from mainline.
