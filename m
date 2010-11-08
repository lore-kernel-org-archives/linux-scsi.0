From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFCv3 00/21] TCM Core and TCM_Loop patches for v2.6.37
Date: Mon, 8 Nov 2010 10:08:57 -0500
Message-ID: <20101108150857.GA14585@infradead.org>
References: <1287441313-19703-1-git-send-email-nab@linux-iscsi.org>
 <20101108143307.GA22121@infradead.org>
 <20101108234328C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101108234328C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hch@infradead.org, nab@linux-iscsi.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu, hch@lst.de, hare@suse.de, James.Bottomley@suse.de, axboe@kernel.dk, bharrosh@panasas.com
List-Id: linux-scsi@vger.kernel.org

Btw, while I'm at it - target_core_transport.c could defintively use
some split up into smaller files while we're at it.
