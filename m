From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] bnx2fc: setup em for npiv port
Date: Thu, 28 Apr 2011 17:25:35 -0500
Message-ID: <1304029536.2598.41.camel@mulgrave.site>
References: <20110315231329.13280.54456.stgit@vifc.jf.intel.com>
	 <1304029125.10064.36.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44796 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154Ab1D1WZn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2011 18:25:43 -0400
In-Reply-To: <1304029125.10064.36.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>
Cc: Vasu Dev <vasu.dev@intel.com>, linux-scsi@vger.kernel.org

On Thu, 2011-04-28 at 15:18 -0700, Bhanu Gollapudi wrote:
> On Tue, 2011-03-15 at 16:13 -0700, Vasu Dev wrote: 
> > Use fc_exch_mgr_list_clone to setup em for npiv port.
> > 
> > Also remove redundant vport and lport initializations.
> > 
> > Signed-off-by: Vasu Dev <vasu.dev@intel.com>
> 
> Acked-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

This patch hasn't ever been submitted as far as I can tell.

James


