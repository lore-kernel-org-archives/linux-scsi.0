From: Christoph Hellwig <hch@infradead.org>
Subject: Re: nvmf question - synchronization between target/initiator
 regarding partitions
Date: Thu, 10 Aug 2017 02:16:26 -0700
Message-ID: <20170810091626.GA21958@infradead.org>
References: <82c4d1d8-ffa9-fa99-df58-05e2945eafdc@linux.vnet.ibm.com>
 <c382184a-1621-c6b2-2a20-bd16498be998@suse.de>
 <4c199e9e-ed58-5a5b-cedc-2d3c3bc1464c@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4c199e9e-ed58-5a5b-cedc-2d3c3bc1464c@linux.vnet.ibm.com>
Sender: linux-block-owner@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, vnarasimhan@in.ibm.com, Mauricio pIO <mauricfo@linux.vnet.ibm.com>, Brian J King <bjking1@us.ibm.com>, Murali N Iyer <mniyer@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 07, 2017 at 02:29:47PM -0300, Guilherme G. Piccoli wrote:
> Thanks for your feedback Hannes, agreed!

And btw, you'll see similar results with the SCSI target or nbd,
so it's not really nvme specific.
