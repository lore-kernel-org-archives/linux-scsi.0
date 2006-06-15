From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: PATCH: Quieten sparse on lpfc driver
Date: Thu, 15 Jun 2006 09:17:27 -0700
Message-ID: <1150388248.3143.45.camel@mulgrave.il.steeleye.com>
References: <1150386046.3490.94.camel@localhost.localdomain>
	 <20060615152754.GS27946@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:54220 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030754AbWFOQR5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 12:17:57 -0400
In-Reply-To: <20060615152754.GS27946@ftp.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org

On Thu, 2006-06-15 at 16:27 +0100, Al Viro wrote:
> Al, sitting on ~200 patches of such kind, including

Well .. scsi-misc is collecting for the next cycle.  Additionally the
patches that affect maintained drivers, like lpfc, need to go through
the maintainers of those drivers, so now would be a good time to begin
preparing this for that cycle.

James


