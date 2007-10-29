From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [2.6 patch] scsi/seagate.c: remove dead code
Date: Mon, 29 Oct 2007 11:44:17 +0200
Message-ID: <4725AB71.6000308@panasas.com>
References: <20071028155142.GB7227@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa3.bezeqint.net ([192.115.104.17]:55875 "EHLO sa3.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbXJ2Jo1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Oct 2007 05:44:27 -0400
In-Reply-To: <20071028155142.GB7227@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Oct 28 2007 at 17:51 +0200, Adrian Bunk <bunk@kernel.org> wrote:
> This patch removes obviously dead code.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  drivers/scsi/seagate.c |    2 --
>  1 file changed, 2 deletions(-)
> 

Actually I have sent a patch to completely remove this driver.
http://www.spinics.net/lists/linux-scsi/msg20308.html

Does any one objects?

Boaz
