From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6 patch] drivers/scsi/FlashPoint.c: cleanups
Date: Sun, 24 Apr 2005 08:26:10 +0100
Message-ID: <20050424072610.GA13662@infradead.org>
References: <20050423221712.GJ4355@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:65005 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262279AbVDXH0O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Apr 2005 03:26:14 -0400
Content-Disposition: inline
In-Reply-To: <20050423221712.GJ4355@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Apr 24, 2005 at 12:17:12AM +0200, Adrian Bunk wrote:
> This patch contains cleanups including the following:
> - remove #ifdef'ed code for other OS's
> - remove other unused code
> - make needlessly global code static

I'd rather not touch this file currently.  It's glued toghether from
lots of separate files in the original code.  Before doing cleanups
I'd rather split it into all these files first as the file is a huge
mess as-is.

