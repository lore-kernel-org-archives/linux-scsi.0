From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Question about scsi_device_online() usage in mptscsih
Date: Thu, 14 Apr 2005 19:54:12 +0100
Message-ID: <20050414185412.GA6929@infradead.org>
References: <20050402053557.GA22422@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36743 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261437AbVDNSyU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Apr 2005 14:54:20 -0400
Content-Disposition: inline
In-Reply-To: <20050402053557.GA22422@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Eric.Moore@lsil.com, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Sat, Apr 02, 2005 at 02:35:57PM +0900, Tejun Heo wrote:
>  Hello, Eric.
>  Hello, James.
> 
>  I've been working on new SCSI state model and was checking on
> scsi_device_online() users.  As the state model is going to change, I
> need to audit device state usages in lldd's and I'm having difficult
> time understanding why scsi_device_online() is used in mptscsih.
> 
>  In mptscsih.c, mptscsih_flush_running_cmds() uses
> scsi_device_online() to determine whether or not dma-unmap data area
> of active commands.  This was added in the changeset 1.1371.776.1 by
> Eric Moore with the comment "MPT Fusion add back FC909 support".  Can
> you please explain me why and how scsi_device_online() condition is
> used here?

I brought that issue up a while ago, but we didn't really get anywhere,
see the "fix dma mapping leak in fusion" thread on linux-scsi.

