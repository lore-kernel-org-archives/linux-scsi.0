From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: fix SSP IU status print-out
Date: Tue, 02 Oct 2007 09:20:57 -0500
Message-ID: <1191334857.3530.39.camel@localhost.localdomain>
References: <20070930140317.GA7134@havoc.gtf.org>
	 <4702399A.9010708@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:33999 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752372AbXJBOVD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 10:21:03 -0400
In-Reply-To: <4702399A.9010708@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 2007-10-02 at 08:29 -0400, Jeff Garzik wrote:
> James, what is the upstream status of my two aic94xx bug fixes?
> 
> Have they been sent to Linus yet?
> 
> Since you seem M.I.A., I'll send them upstream if I do not hear from you 
> today.

They're hardly -rc8 critical bug fixes, since no-one has noticed their
effects for about 5 kernel releases.  I'll stick them into scsi-misc
with the rest of the pending stuff.

And going away for the Weekend is hardly MIA.

James


