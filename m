From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/5] nvme: move the retries count to struct nvme_request
Date: Thu, 6 Apr 2017 10:38:26 +0200
Message-ID: <20170406083826.GA32535@lst.de>
References: <20170405141856.1862-1-hch@lst.de> <20170405141856.1862-5-hch@lst.de> <20170405151430.GS20181@localhost.localdomain> <5a5f1f1.8f7d.15b4267e21e.Coremail.liaohengquan1986@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5a5f1f1.8f7d.15b4267e21e.Coremail.liaohengquan1986@163.com>
Sender: linux-block-owner@vger.kernel.org
To: =?utf-8?B?5buW5Lqo5p2D?= <liaohengquan1986@163.com>
Cc: Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 06, 2017 at 04:35:56PM +0800, 廖亨权 wrote:
> Hi, Guys,
>               I want to ask if there is any plan to plant the NVMe driver to Vxworks OS?Thank  you so much.---end quoted text---

The Linux NVMe team has no plans for a Vxworks NVMe driver at the moment.
