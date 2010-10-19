From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6] bfa: cleanups and fixes
Date: Tue, 19 Oct 2010 13:34:38 -0400
Message-ID: <20101019173437.GA9540@infradead.org>
References: <1287446815-25367-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37984 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab0JSRek (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Oct 2010 13:34:40 -0400
Content-Disposition: inline
In-Reply-To: <1287446815-25367-1-git-send-email-huangj@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, adapter_linux_open_src_team@brocade.com

On Mon, Oct 18, 2010 at 05:06:55PM -0700, Jing Huang wrote:
> This patch set continues to clean up bfa driver by replacing the OS
> wrapper functions and macros with linux native ones. We also provide fixes
> for the following issue reported by Randy Dunlap (randy.dunlap@oracle.com):
> 1) compile warning of frame size over 1024 in gcc 4.4.
> 2) commments blocks that begin with /**.


The whole series looks good to me.  Thanks for making some progress.

