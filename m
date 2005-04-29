From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Emulex fibre channel HBA support and SAN connection
Date: Fri, 29 Apr 2005 19:15:24 +0100
Message-ID: <20050429181524.GA11660@infradead.org>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C2062981@xbl3.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:65184 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262860AbVD2SPa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2005 14:15:30 -0400
Content-Disposition: inline
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C2062981@xbl3.ad.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: alexdeucher@gmail.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Apr 29, 2005 at 02:08:01PM -0400, James.Smart@Emulex.Com wrote:
> We are putting together such a document that will be placed
> out on SourceForge.

My idea was to put in in the driver actually, so that the ->probe routine
can print an error message for the user.

