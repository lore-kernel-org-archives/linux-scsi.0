From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 12/21] advansys: Sort out debug macros
Date: Tue, 02 Oct 2007 22:02:09 -0400
Message-ID: <4702F821.2020900@garzik.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <1191376542311-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:54711 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbXJCCCL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 22:02:11 -0400
In-Reply-To: <1191376542311-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> Replace ASC_DBG{,1,2,3,4,5} with a single variadic macro ASC_DBG.  As
> suggested by Jeff Garzik, include DRV_NAME and __FUNCTION__ in the output.
> Change all callers to no longer include the function name in the string.
> 
> Enabling ADVANSYS_DEBUG to test this feature shows a lot of other problems
> that need to be fixed:
>  - Reorder asc_prt_* functions now that their prototypes have been removed.
>  - There is no longer a struct device in ASC_DVC_CFG/ADV_DVC_CFG, and it
>    wasn't necessarily a PCI device to begin with.  Print the bus_id from
>    asc_board->dev instead.
>  - isr_callback no longer exists.
>  - ASC_DBG_PRT_SCSI_CMND isn't being used, so delete asc_prt_scsi_cmnd
>    too.
>  - A missing semicolon
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

ACK


