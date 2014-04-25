From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: replace numeric messages with string error
	messages when blk_execute_rq fails.  Also add printing of sense
	info.
Date: Fri, 25 Apr 2014 15:12:19 +0200
Message-ID: <20140425131219.GA20644@lst.de>
References: <1398167056-14582-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45078 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbaDYNMW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2014 09:12:22 -0400
Content-Disposition: inline
In-Reply-To: <1398167056-14582-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@Parallels.com, hch@lst.de

On Tue, Apr 22, 2014 at 01:44:16PM +0200, Maurizio Lombardi wrote:
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)


Looks useful, but why do we have basically two copies of the same
code for different commands? Looking at them in detail they mostly look
like copies of scsi_execute/scsi_execute_req_flags and should be switched
to that.

