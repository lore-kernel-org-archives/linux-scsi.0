From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 'modprobe mptctl' fails after 'modprobe aic79xx'
Date: Mon, 25 Oct 2004 13:50:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041025125046.GA32554@infradead.org>
References: <20041025105112.GQ7803@orion.czech.sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:50700 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261790AbUJYMur (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2004 08:50:47 -0400
Content-Disposition: inline
In-Reply-To: <20041025105112.GQ7803@orion.czech.sun.com>
List-Id: linux-scsi@vger.kernel.org
To: Jan Lana <jan.lana@Sun.COM>
Cc: linux-scsi@vger.kernel.org, Tomas Vesely <Tomas.Vesely@Sun.COM>

On Mon, Oct 25, 2004 at 12:51:12PM +0200, Jan Lana wrote:
> Hi,
> 
> I have found a strange behavior of module mptbase (Fusion MPT (base + ScsiHost) drivers).
> There is a bugreport:
> 
> 
> [1.] One line summary of the problem:    
>      'modprobe mptbase' after 'modprobe aic79xx' fails.

This should be fixed in 2.6.10-rc1.

