From: Jan Lana <jan.lana@Sun.COM>
Subject: Re: 'modprobe mptctl' fails after 'modprobe aic79xx'
Date: Mon, 25 Oct 2004 15:37:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041025133753.GR7803@orion.czech.sun.com>
References: <20041025105112.GQ7803@orion.czech.sun.com> <20041025125046.GA32554@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nwkea-mail-1.sun.com ([192.18.42.13]:18842 "EHLO
	nwkea-mail-1.sun.com") by vger.kernel.org with ESMTP
	id S261814AbUJYNia (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2004 09:38:30 -0400
Content-Disposition: inline
In-Reply-To: <20041025125046.GA32554@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Tomas Vesely <Tomas.Vesely@Sun.COM>

On Mon, Oct 25, 2004 at 01:50:46PM +0100, Christoph Hellwig wrote:
> On Mon, Oct 25, 2004 at 12:51:12PM +0200, Jan Lana wrote:
> > Hi,
> > 
> > I have found a strange behavior of module mptbase (Fusion MPT (base + ScsiHost) drivers).
> > There is a bugreport:
> > 
> > 
> > [1.] One line summary of the problem:    
> >      'modprobe mptbase' after 'modprobe aic79xx' fails.
> 
> This should be fixed in 2.6.10-rc1.

Thanks, I will test it on stable version 2.6.10.

- Jenda 
