From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] libata: enable SATA disk fua detection on default
Date: Wed, 9 May 2012 09:23:17 -0400
Message-ID: <20120509132317.GA24014@infradead.org>
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com>
 <4FAA02DA.3000201@gmail.com>
 <20120509061956.GA12329@gmail.com>
 <20120509082527.GA10674@infradead.org>
 <20120509093016.GA12754@gmail.com>
 <20120509111243.GB29593@infradead.org>
 <20120509124804.GA13329@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120509124804.GA13329@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Zheng Liu <wenqing.lz@taobao.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 09, 2012 at 08:48:04PM +0800, Zheng Liu wrote:
> Thanks for your explanation.  It seems that there still has a problem.
> If I set the disk to write through mode, I need to modify my application
> to remove all of flush/sync operations.  It is unacceptable for us.

You don't have to - the kernel will not send a SYNCHRONIZE CACHE command
unless the disk advertises a write back cache.

