From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/3] block: add blk-iopoll, a NAPI like approach
	forblock  devices
Date: Thu, 20 Aug 2009 13:38:51 +0200
Message-ID: <20090820113851.GI12579@kernel.dk>
References: <1249588685-4662-1-git-send-email-jens.axboe@oracle.com> <1249588685-4662-2-git-send-email-jens.axboe@oracle.com> <20090806223257.0c33cf15@lxorguk.ukuu.org.uk> <20090807063745.GQ12579@kernel.dk> <4A7BE80A.6080808@garzik.org> <20090807085004.GV12579@kernel.dk> <20090807110517.GW12579@kernel.dk> <20090807113146.GX12579@kernel.dk> <20090819190804.GP12579@kernel.dk> <B021CBAD133A4E45A4BF6E6BDFDCA28F@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:53061 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbZHTLiu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 07:38:50 -0400
Content-Disposition: inline
In-Reply-To: <B021CBAD133A4E45A4BF6E6BDFDCA28F@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack wang <jack_wang@usish.com>
Cc: 'Jeff Garzik' <jeff@garzik.org>, 'Alan Cox' <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com

On Thu, Aug 20 2009, jack wang wrote:
> Could you tell me what tool do you use to get the IO benchmark?  

Sure, it's basically always the same tool: fio.

git clone git://git.kernel.dk/fio.git

or just grab the latest snapshot:

http://brick.kernel.dk/snaps/fio-git-latest.tar.gz

-- 
Jens Axboe

