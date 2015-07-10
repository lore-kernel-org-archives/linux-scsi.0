From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: Re: [PATCHv2 1/1] ipr: Fix invalid array indexing for HRRQ
Date: Fri, 10 Jul 2015 15:58:08 -0300
Message-ID: <87a8v3c01r.fsf@linux.vnet.ibm.com>
References: <201506251344.t5PDiZLv025988@d03av03.boulder.ibm.com>
	<558C11F0.6020505@suse.cz> <558C23F4.8050709@linux.vnet.ibm.com>
	<558C258E.4000002@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:34108 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932650AbbGJS6K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jul 2015 14:58:10 -0400
Received: from /spool/local
	by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
	Fri, 10 Jul 2015 15:58:07 -0300
In-Reply-To: <558C258E.4000002@linux.vnet.ibm.com> (Brian King's message of
	"Thu, 25 Jun 2015 11:00:14 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Jiri Slaby <jslaby@suse.cz>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, stable@vger.kernel.org

Brian King <brking@linux.vnet.ibm.com> writes:

>  drivers/scsi/ipr.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)

Hi Brian,

The changes look good to me.  Please add

Reviewed-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

Thanks,

-- 
Gabriel Krisman Bertazi

