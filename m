From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Add compat_ioctl to scsi host structure
Date: Tue, 18 Jan 2005 07:35:36 -0800
Message-ID: <1106062536.5151.2.camel@mulgrave>
References: <20050118110354.GB43344@muc.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:42880 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261330AbVARPgi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 10:36:38 -0500
In-Reply-To: <20050118110354.GB43344@muc.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-01-18 at 12:03 +0100, Andi Kleen wrote:
> Add a call vector for 32bit compat ioctls to the SCSI host
> structure. This is needed for some followon patches.
> 
> Signed-off-by: Andi Kleen <ak@muc.de>

Shouldn't this also be surrounded by #ifdef CONFIG_COMPAT (on the
grounds that you never fill it in unless CONFIG_COMPAT is defined)?

James


