From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: complete boot failure in 4.5-rc1 caused by nvme: make SG_IO
 support optional
Date: Tue, 09 Feb 2016 07:37:37 -0800
Message-ID: <1455032257.2340.1.camel@HansenPartnership.com>
References: <1454783624.2809.6.camel@HansenPartnership.com>
	 <20160207092241.GA15331@lst.de>
	 <1454861040.2329.4.camel@HansenPartnership.com>
	 <56B7C527.6050300@kernel.dk> <20160209125011.GC25353@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160209125011.GC25353@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-02-09 at 13:50 +0100, Christoph Hellwig wrote:
> Jens,
> 
> do you want a 'default y' patch or just a better description?  I'd be
> happy to send either one.

Since it only appears to be SUSE and they've now been told, better
description is fine.

James
