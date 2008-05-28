From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: megaraid_sata vs megasr
Date: Wed, 28 May 2008 09:44:50 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229010EF1F5@NAMAIL2.ad.lsil.com>
References: <200805281617.45169.maarten.vanraes@telenet.be>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:40223 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbYE1PpG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2008 11:45:06 -0400
Content-class: urn:content-classes:message
In-Reply-To: <200805281617.45169.maarten.vanraes@telenet.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maarten Vanraes <maarten.vanraes@telenet.be>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wednesday, May 28, 2008 8:18 AM, Maarten Vanraes wrote:
> 
> So in effect, you are telling me that we bought fakeraid 
> cards... since this 
> is the "recommended driver"? is the card a hardware raid? or software.
> 
> We had specifically asked for hardware raid... :-(
> 

I worked on megaraid team some five years ago, now I work on mpt fusion.
I can't tell you what the recommended megaraid cards, as they have
changed since then from U320.   The mpt fusion cards come with Raid
levels 0, 1, and 1 enhanced, which is implemented in hardware/firmware.


You could try looking here:  
http://www.lsi.com/storage_home/products_home/internal_raid/index.html
