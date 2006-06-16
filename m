From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Winbond Flash memory device drivers
Date: Fri, 16 Jun 2006 08:14:50 -0700
Message-ID: <1150470891.25358.26.camel@mulgrave.il.steeleye.com>
References: <448639A5.7060304@winbond.com.tw>
	 <4486E0B1.9050709@interlog.com>  <4487740F.5070004@winbond.com>
	 <1149817321.3276.31.camel@mulgrave.il.steeleye.com>
	 <449207FF.1020905@winbond.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:43411 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751446AbWFPPPl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jun 2006 11:15:41 -0400
In-Reply-To: <449207FF.1020905@winbond.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, PI14 SJIN <SJin@winbond.com>, dzshen@winbond.com.tw

On Fri, 2006-06-16 at 09:23 +0800, dezheng shen wrote:
>    We are from Winbond Electronics and there is something weird we would 
> like to confirm.
> 
>    We already subscribed to linux-kernel and linux-scsi lists and we are 
> able to receive emails from both of them. However, we couldn't send 
> email to either list. Could you figure it our where went wrong? For 
> example, when I sent emails using dzshen@winbond.com but my memeber 
> couldn't receive my email his account sjin@winbond.com.

The code went to the list, but the email was 124k in size, so the list
dropped it (I think it has a size limit of around 100k).  If you look at
how people submit drivers on the mailing list archive:

http://marc.theaimsgroup.com/?l=linux-scsi

You'll see that people tend to submit patches in multiple chunks to get
around this.

James


