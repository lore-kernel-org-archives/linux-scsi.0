From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fix the fix for multiple HBA problem with transport
	classes
Date: Wed, 02 Feb 2005 14:56:58 -0600
Message-ID: <1107377819.4541.20.camel@mulgrave>
References: <0B1E13B586976742A7599D71A6AC733C02F331@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:6043 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262515AbVBBU5H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Feb 2005 15:57:07 -0500
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F331@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-02-02 at 15:55 -0500, James.Smart@Emulex.Com wrote:
> Testing was showing transport devices not being enumerated.
> 
> The reason was the wrong attribute container was being compared
> against in the "match" functions.  This patch fixes it.

OK, I confess ... I quietly fixed these three before sending the patch
to Linus.

James


