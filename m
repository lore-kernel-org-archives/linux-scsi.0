From: Alexey Dobriyan <adobriyan@mail.ru>
Subject: Re: [2.6 patch] drivers/scsi/FlashPoint.c: cleanups
Date: Mon, 25 Apr 2005 13:34:49 +0400
Message-ID: <E1DPzzN-000J3V-00.adobriyan-mail-ru@f26.mail.ru>
References: <20050423221712.GJ4355@stusta.de>
Reply-To: Alexey Dobriyan <adobriyan@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from f26.mail.ru ([194.67.57.194]:34057 "EHLO f26.mail.ru")
	by vger.kernel.org with ESMTP id S262558AbVDYJev (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2005 05:34:51 -0400
In-Reply-To: <20050423221712.GJ4355@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> This patch contains cleanups including the following:
> - remove #ifdef'ed code for other OS's
> - remove other unused code
> - make needlessly global code static

FYI, (1) and part of your (2) are already sitting in -kj (splitted).

http://coderock.org/kj/2.6.12-rc3-kj/split/defines-drivers_scsi_FlashPoint.patch
http://coderock.org/kj/2.6.12-rc3-kj/split/comments-drivers_scsi_FlashPoint

And I hope cleaning FlashPoint mess will be splitted.
