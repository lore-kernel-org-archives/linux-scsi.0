From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6 patch] drivers/scsi/qla2xxx/: cleanups
Date: Mon, 28 Feb 2005 21:29:20 +0000
Message-ID: <20050228212920.GA18162@infradead.org>
References: <20050228210024.GM4021@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:55532 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261752AbVB1V3a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2005 16:29:30 -0500
Content-Disposition: inline
In-Reply-To: <20050228210024.GM4021@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: andrew.vasquez@qlogic.com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Feb 28, 2005 at 10:00:24PM +0100, Adrian Bunk wrote:
> This patch contains the following cleanups:
> - make needlessly global code static
> - kill the unused global *_version and *_version_str variables
>   in the firmware files

The firmware files are generated, so it'd be better to leave them
alone.
