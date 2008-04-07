From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH 1/3] debloat aic7xxx and aic79xx drivers
Date: Mon, 7 Apr 2008 20:01:37 +0200
Message-ID: <200804072001.37951.vda.linux@googlemail.com>
References: <200803230440.40685.vda.linux@googlemail.com> <200803230441.22926.vda.linux@googlemail.com> <47F9F7FD.908@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:18727 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbYDGSCB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2008 14:02:01 -0400
Received: by fk-out-0910.google.com with SMTP id 19so2133993fkr.5
        for <linux-scsi@vger.kernel.org>; Mon, 07 Apr 2008 11:01:59 -0700 (PDT)
In-Reply-To: <47F9F7FD.908@suse.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Monday 07 April 2008 12:31, Hannes Reinecke wrote:
> Hi Denys,
> 
> Denys Vlasenko wrote:
> > Deinlines and moves big functions from .h to .c files.
> > Adds prototypes for ahc_lookup_scb and ahd_lookup_scb to .h files.
> > 
> > Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> > --
> > vda
> Patch looks good to me.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Thanks! Please, queue it up in linux-scsi tree.
--
vda
