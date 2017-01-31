From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 09/10] ide: don't abuse cmd_type
Date: Tue, 31 Jan 2017 11:11:52 -0500 (EST)
Message-ID: <20170131.111152.1190518672369292507.davem@davemloft.net>
References: <1485878251-6107-1-git-send-email-hch@lst.de>
        <1485878251-6107-10-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1485878251-6107-10-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: hch@lst.de
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Tue, 31 Jan 2017 16:57:30 +0100

> Currently the legacy ide driver defines several request types of it's own,
> which is in the way of removing that field entirely.
> 
> Instead add a type field to struct ide_request and use that to distinguish
> the different types of IDE-internal requests.
> 
> It's a bit of a mess, but so is the surrounding code..
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: David S. Miller <davem@davemloft.net>
