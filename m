From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [2.6 patch] let AIC7{9,X}XX_BUILD_FIRMWARE depend on !PREVENT_FIRMWARE_BUILD
Date: Sun, 1 Aug 2004 21:11:18 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040801191118.GA7402@mars.ravnborg.org>
References: <20040801185543.GB2746@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepc.post.tele.dk ([195.41.46.237]:28717 "EHLO
	pfepc.post.tele.dk") by vger.kernel.org with ESMTP id S266128AbUHATKL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Aug 2004 15:10:11 -0400
Content-Disposition: inline
In-Reply-To: <20040801185543.GB2746@fs.tum.de>
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@fs.tum.de>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, Sam Ravnborg <sam@ravnborg.org>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Aug 01, 2004 at 08:55:44PM +0200, Adrian Bunk wrote:
> 
> The patch below lets AIC7{9,X}XX_BUILD_FIRMWARE depend on 
> !PREVENT_FIRMWARE_BUILD.

Justin, I agree with this change. Please let me know if I shall forward
the patch to Linus, or you will take care.

	Sam
