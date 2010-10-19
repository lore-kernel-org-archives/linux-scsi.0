From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] bfa: replace endian swap macros with the ones
 provided by linux
Date: Tue, 19 Oct 2010 10:09:21 -0400
Message-ID: <20101019140920.GA13348@infradead.org>
References: <1287447050-27777-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40377 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab0JSOJX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Oct 2010 10:09:23 -0400
Content-Disposition: inline
In-Reply-To: <1287447050-27777-1-git-send-email-huangj@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, adapter_linux_open_src_team@brocade.com

On Mon, Oct 18, 2010 at 05:10:50PM -0700, Jing Huang wrote:
> This patch replaces endian swap macros with the ones provided by the linux.
> 
> Signed-off-by: Jing Huang <huangj@brocade.com>

Is this enough that

	make C=2 CF="-D__CHECK_ENDIAN__"

gives you clean enough output to actually verify all the endiness
conversions?

