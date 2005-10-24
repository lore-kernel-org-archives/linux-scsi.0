From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: infinite loop with 36 Byte inquiry (sbp2 regression in	2.6.14-rcX)
Date: Mon, 24 Oct 2005 09:17:38 +0200
Message-ID: <435C8A92.2080803@s5r6.in-berlin.de>
References: <435ADA6D.4040705@s5r6.in-berlin.de> <1130107402.3437.54.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:48797 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751059AbVJXHSM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 03:18:12 -0400
In-Reply-To: <1130107402.3437.54.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
Cc: Ben Collins <bcollins@debian.org>

James Bottomley wrote:
> However, at a brief examination it looks like you do quite a lot of
> response snooping.  This always was broken for commands from userspace,
> but it's completely broken now we only use scatter/gather commands from
> block.

BTW, a lot of the snooping and mangling in sbp2 was removed a while ago
by the RBC cache patch. The sbp2 portion of the patch was backed out
from mainline (but kept in the linux1394.org trunk) due to initial
stability issues. It will be merged soon.
-- 
Stefan Richter
-=====-=-=-= =-=- ==---
http://arcgraph.de/sr/
