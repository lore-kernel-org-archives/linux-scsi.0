From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] tmscsim: implement change_queue_depth
Date: Mon, 27 Dec 2004 12:31:38 -0600
Message-ID: <1104172298.7447.10.camel@mulgrave>
References: <Pine.LNX.4.60.0412221305140.2636@poirot.grange>
	 <1103826862.5290.39.camel@mulgrave>
	 <Pine.LNX.4.60.0412240126400.27610@poirot.grange>
	 <1104076166.5268.22.camel@mulgrave>
	 <Pine.LNX.4.60.0412262034030.3808@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:3045 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261940AbUL0Sbr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Dec 2004 13:31:47 -0500
In-Reply-To: <Pine.LNX.4.60.0412262034030.3808@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-12-26 at 22:49 +0100, Guennadi Liakhovetski wrote:
> Ok. Would it make sense / be accepted to change this sitation by either 1) 
> adding a new function __scsi_adjust_queue_depth() which would pass the 
> return code of the block-layer, or 2) modifying the existing function to 
> return an error? 1) has disadvantages, that it's a) confusing, b) even 
> more confusing, because that other function also has to be exported. 2) 
> has the disadvantage of changing an exported API in the "stable" series... 
> I would go for 2) especially with the current extended understanding of 
> the "stable" kernel series. I could roll a patch for either of these 2 
> possibilities, if the latter is chosen I could try to fix the current 
> users to check the return code.

To be honest, unless you can find a driver that cares about this
failure, I don't think so.

James


