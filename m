From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] normalize fixed and descriptor sense data
Date: Sun, 29 Aug 2004 10:59:34 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040829085934.GA27515@lst.de>
References: <412EF74A.1070106@torque.net> <4130129F.40503@torque.net> <20040828202335.GA18962@lst.de> <413124F3.6090505@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:13997 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267330AbUH2I7k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Aug 2004 04:59:40 -0400
Content-Disposition: inline
In-Reply-To: <413124F3.6090505@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Sun, Aug 29, 2004 at 10:36:03AM +1000, Douglas Gilbert wrote:
> I'm happy with this patch. Now it's my turn to be a reviewer ...
> The "Ignored if NULL." sentence above is no longer correct and
> should be removed. Actually it's my oversight.

Heh, indeed.  James, can you just remove " Ignored if NULL." from the
sshdr paramter description when applying?

