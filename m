From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] lpfc : add module parameter that allows adapter
	instances to avoid attachment
Date: Thu, 26 Mar 2009 15:19:07 -0500
Message-ID: <1238098747.3342.54.camel@localhost.localdomain>
References: <1238097300.27023.2.camel@ogier>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34006 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495AbZCZUTG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Mar 2009 16:19:06 -0400
In-Reply-To: <1238097300.27023.2.camel@ogier>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Thu, 2009-03-26 at 15:55 -0400, James Smart wrote:
> This patch adds a module parameter that supplies a text string containing a
> list of PCI <bus>:<slot>.<func> values to identify adapter instances that
> should *not* be attached to by the driver.
> 
> -- james s
> 
> 
>  Signed-off-by: James Smart <james.smart@emulex.com>

Is there a reason why you can't just use the generic unbind interface?

James


