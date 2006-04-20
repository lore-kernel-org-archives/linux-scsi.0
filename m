From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] SCSI: implement scsi_eh_schedule_cmd()
Date: Thu, 20 Apr 2006 14:01:13 +0100
Message-ID: <20060420130113.GA10415@infradead.org>
References: <20060419184916.22608.qmail@web31809.mail.mud.yahoo.com> <4446ECCF.7080000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4446ECCF.7080000@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: ltuikov@yahoo.com, Patrick Mansfield <patmans@us.ibm.com>, Jeff Garzik <jgarzik@pobox.com>, hch@lst.de, James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, arjan@infradead.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 20, 2006 at 11:07:11AM +0900, Tejun Heo wrote:
> James and Jeff, any opinion on this matter?

I think you hack looks okayish.  But I want to see the whole libata
->eh_strategy_handler first.

