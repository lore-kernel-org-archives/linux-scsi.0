From: Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH 21/34] aacraid: Drop __TIME__ usage
Date: Tue, 19 Apr 2011 00:20:00 +0200
Message-ID: <20110418222000.GD29882@sepie.suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
 <1302015561-21047-22-git-send-email-mmarek@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab1DRWUB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Apr 2011 18:20:01 -0400
Content-Disposition: inline
In-Reply-To: <1302015561-21047-22-git-send-email-mmarek@suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, linux-scsi@vger.kernel.org

On Tue, Apr 05, 2011 at 04:59:08PM +0200, Michal Marek wrote:
> The kernel already prints its build timestamp during boot, no need to
> repeat it in random drivers and produce different object files each
> time.
> 
> Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  drivers/scsi/aacraid/linit.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)

Applied to kbuild-2.6.git#trivial.

Michal

