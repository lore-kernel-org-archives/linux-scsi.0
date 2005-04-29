From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Emulex fibre channel HBA support and SAN connection
Date: Fri, 29 Apr 2005 12:42:25 +0100
Message-ID: <20050429114225.GA4839@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C201ABC8@xbl3.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40600 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262489AbVD2Lm3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2005 07:42:29 -0400
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C201ABC8@xbl3.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: alexdeucher@gmail.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Apr 29, 2005 at 07:37:01AM -0400, James.Smart@Emulex.Com wrote:
> Based on the "Unknown IOCB command data" message, this appears to be out of date firmware on the adapter. See http://www.emulex.com/ts/indexemu.html.  There are some hints on downloading firmware at the tail end of  http://sourceforge.net/forum/forum.php?thread_id=1130082&forum_id=355154. 

I've seeb quite a bit of these old firmware problems, maybe lpfc should
have a table of minimum required firmware versions for each HBA type?

