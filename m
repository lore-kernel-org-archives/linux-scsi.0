From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [BK PATCH] SCSI updates for 2.6.6
Date: 11 May 2004 14:54:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1084305274.2570.12.camel@mulgrave>
References: <Pine.LNX.4.44.0405112125150.3836-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:55703 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263366AbUEKTyx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 May 2004 15:54:53 -0400
In-Reply-To: <Pine.LNX.4.44.0405112125150.3836-100000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, 2004-05-11 at 14:29, Guennadi Liakhovetski wrote:
> I hoped the tmscsim 64-bit bugfix would somehow find its way into the
> mainstream after 2.6. Does it still have a chance?

The DC390 is a maintained driver:

DC390/AM53C974 SCSI driver
P:	Kurt Garloff
M:	garloff@suse.de
W:	http://www.garloff.de/kurt/linux/dc390/
S:	Maintained

You need to get the maintainer to approve acceptance.

James


