From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/1] ipr: Fix for adapter shutdown issue
Date: Wed, 15 Jun 2005 10:28:12 -0500
Message-ID: <1118849292.5045.27.camel@mulgrave>
References: <200506151515.j5FFFNQA020480@d01av01.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:3240 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261170AbVFOP2Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 11:28:24 -0400
In-Reply-To: <200506151515.j5FFFNQA020480@d01av01.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, haren@us.ibm.com

On Wed, 2005-06-15 at 10:15 -0500, brking@us.ibm.com wrote:
> Haren found this in some recent kexec testing. Without this fix, the
> ipr adapter's write cache never gets flushed. I'd like to see this
> pushed into 2.6.12 if possible.

Just out of curiosity, what are you doing with the SYNCHRONIZE_CACHE
that comes down from sd on shutdown?

James


