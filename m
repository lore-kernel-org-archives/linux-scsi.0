From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] - mptfusion - fix panic loading driver statically compile d
Date: Thu, 28 Apr 2005 23:27:39 +0100
Message-ID: <20050428222739.GA26015@infradead.org>
References: <91888D455306F94EBD4D168954A9457C0225D199@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:13195 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262235AbVD1W1l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2005 18:27:41 -0400
Content-Disposition: inline
In-Reply-To: <91888D455306F94EBD4D168954A9457C0225D199@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, akpm@osdl.org

On Thu, Apr 28, 2005 at 04:15:23PM -0600, Moore, Eric Dean wrote:
> This patch can also be found at this URL:
> ftp://ftp.lsil.com/HostAdapterDrivers/linux/FiberChannel/2.6-kernel/3.03.01/
> 
> Changelog:
> (1) For statically linked drivers, fusion_init was not called,
> added call from mpt_register so its called when one of the scsi lld load.

please find the real cause for this.  The kernel does call all module_init
handlers.  Is your link order incorrect maybe?

