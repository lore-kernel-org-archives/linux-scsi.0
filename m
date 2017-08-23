From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] storvsc: do not assume SG list is continuous when doing bounce buffers (for 4.1 stable only)
Date: Wed, 23 Aug 2017 11:22:07 -0400
Message-ID: <yq1ziaq9un4.fsf@oracle.com>
References: <1503379905-18908-1-git-send-email-longli@exchange.microsoft.com>
        <20170822062841.GA1061@infradead.org>
        <MWHPR21MB0190D1C8C3FAF25AE283ABCFCE840@MWHPR21MB0190.namprd21.prod.outlook.com>
        <20170823064319.GA19373@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170823064319.GA19373@infradead.org> (Christoph Hellwig's
        message of "Tue, 22 Aug 2017 23:43:19 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Christoph,

> Ok.  If the stable maintainers are ok with your small fix
> I'm not going to complain too loudly.  But I'm always worried about
> stable trees divering too much from mainline.

The seemingly innocuous transition from SG_GAPS to virt boundary has
caused several data corruption regressions in the distro kernels. So has
the corresponding conversion of storvsc.

As a result, getting the current upstream code into 4.1 would mean
backporting and testing a significant amount of both block layer and
driver code. I don't think it's worth the risk. This patch is simple and
the path of least resistance.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
