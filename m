From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] switch scsi upper driver probing to the driver model
Date: Sat, 17 May 2003 09:35:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030517163538.GA3459@beaverton.ibm.com>
References: <20030516182039.A7369@lst.de> <20030516235718.GA3260@beaverton.ibm.com> <20030517111723.A14681@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:55187 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S261624AbTEQQUa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 May 2003 12:20:30 -0400
Content-Disposition: inline
In-Reply-To: <20030517111723.A14681@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Christoph Hellwig [hch@lst.de] wrote:
> 
> Okay, here's the patch to remove the strange kdev and type attributes
> that caused this problems.  All the useful attributes are still left,
> they're attributes of the right struct device.

Thanks, I am doing insmod / rmmod with sd, sg, sr, and st upper levels
binding and unbinding.

-andmike
--
Michael Anderson
andmike@us.ibm.com

