From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 10/32] bfa: IOC changes: Support faster recovery and
 split bfa_ioc.c into ASIC specific code.
Date: Thu, 04 Mar 2010 16:32:10 +0530
Message-ID: <1267700530.31654.135.camel@mulgrave.site>
References: <1267667056-24506-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab0CDLCW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Mar 2010 06:02:22 -0500
In-Reply-To: <1267667056-24506-1-git-send-email-kgudipat@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kgudipat@brocade.com
Cc: linux-scsi@vger.kernel.org, adapter_linux_open_src_team@brocade.com, huangj@brocade.com

On Wed, 2010-03-03 at 17:44 -0800, kgudipat@brocade.com wrote:
> From: Krishna Gudipati <kgudipat@brocade.com>
> 
> Change details:
> 
> 	- Add support for faster IOC recovery after failure.
> 
> 	- Split bfa_ioc.c into three files:
> 		- bfa_ioc.c:    Common code shared between crossbow and catapult ASIC's.
> 		- bfa_ioc_cb.c: Code specific to the crossbow, reg mapping and interrupt related routines.
> 		- bfa_ioc_ct.c: Code specific to the catapult, reg mapping and interrupt related routines.
> 
> 	- Fix to make sure IOC reinitialize's properly on enable request - update the ioc_fwstate reg
> 	  with BFI_IOC_FAIL on ioc disable mbox cmd timeout.
> 
> Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>

This one contains a lot of whitespace problems ... I've fixed them up,
but running scripts/checkpatch.pl on the patch would have been
useful ...

James


