From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: Re: [PATCH] [SCSI] FlashPoint: fix build warning
Date: Fri, 2 Oct 2015 13:31:22 +0530
Message-ID: <20151002080122.GB9346@sudip-pc>
References: <1442412380-1832-1-git-send-email-sudipm.mukherjee@gmail.com>
 <55F9810F.6030004@gonehiking.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34476 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbbJBIB3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2015 04:01:29 -0400
Content-Disposition: inline
In-Reply-To: <55F9810F.6030004@gonehiking.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Khalid Aziz <khalid@gonehiking.org>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Sep 16, 2015 at 08:47:43AM -0600, Khalid Aziz wrote:
> On 09/16/2015 08:06 AM, Sudip Mukherjee wrote:
> >We have been getting a warning about non ANSI function.
> >warning: non-ANSI function declaration of function 'FPT_SccbMgrTableInitAll'
> >
> >Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> >---
> >  drivers/scsi/FlashPoint.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/drivers/scsi/FlashPoint.c b/drivers/scsi/FlashPoint.c
> >index 5c74e4c..867b864 100644
> >--- a/drivers/scsi/FlashPoint.c
> >+++ b/drivers/scsi/FlashPoint.c
> >@@ -2136,7 +2136,7 @@ static unsigned char FPT_SccbMgr_bad_isr(u32 p_port, unsigned char p_card,
> >   *
> >   *---------------------------------------------------------------------*/
> >
> >-static void FPT_SccbMgrTableInitAll()
> >+static void FPT_SccbMgrTableInitAll(void)
> >  {
> >  	unsigned char thisCard;
> >
> >
> 
> Acked-by: Khalid Aziz <khalid@gonehiking.org>
> 
> James, please apply this to your SCSI tree.
Hi James,
A gentle reminder that this is waiting to be applied.

regards
sudip
