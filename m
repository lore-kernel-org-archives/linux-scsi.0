From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Announce] Emulex lpfcdriver v8.0.9 available
Date: Mon, 16 Aug 2004 21:46:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040816214644.A15044@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C02F164@xbl3.ma.emulex.com> <20040816212706.A14780@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:38661 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267947AbUHPUqv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2004 16:46:51 -0400
Content-Disposition: inline
In-Reply-To: <20040816212706.A14780@infradead.org>; from hch@infradead.org on Mon, Aug 16, 2004 at 09:27:06PM +0100
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Mon, Aug 16, 2004 at 09:27:06PM +0100, Christoph Hellwig wrote:
> > To date, the known todos are:
> > - Use mid-layer I/O timers
> > - No Peeking into timer structures
> > - Need to get approvals on all the clock changes, parameter changes, etc.
> > - Add calls to scan functions on new device detection, remove_device on device loss.
> > - Add interfaces to support managability.
> 
> 
>  - streamline I/O submission path
>  - sort out memory allocation issues

- get rid of persistant lun binding support in the driver

