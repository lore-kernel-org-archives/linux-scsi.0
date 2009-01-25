From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC] Quiesce disk revalidate
Date: Sun, 25 Jan 2009 08:20:49 -0600
Message-ID: <1232893249.4586.6.camel@localhost.localdomain>
References: <yq1r63j4hjn.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54499 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753644AbZAYOUx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jan 2009 09:20:53 -0500
In-Reply-To: <yq1r63j4hjn.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Sun, 2009-01-04 at 03:11 -0500, Martin K. Petersen wrote:
> sd_revalidate ends up being called several times during device setup.
> With this patch we print everything during the first scan.  Subsequent
> invocations will only print a message if the parameter in question has
> actually changed (LUN capacity has increased, etc.).
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

OK, there have been no comments or objections.  Reroll against current
scsi-misc (it has 3 rejections) and I'll apply.

James


