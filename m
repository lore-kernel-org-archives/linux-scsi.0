From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 100% repeatable way to send firewire out to lunch permanently
 on 2.6.8.1
Date: Sun, 31 Jul 2005 20:08:39 +0200
Message-ID: <42ED13A7.9070101@s5r6.in-berlin.de>
References: <Pine.LNX.4.44.0507310739320.13193-100000@sasami.anime.net> <42ED0AE6.7020300@s5r6.in-berlin.de> <42ED1073.7010004@s5r6.in-berlin.de> <20050731175946.GA8511@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:29641 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S261860AbVGaSI7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Jul 2005 14:08:59 -0400
In-Reply-To: <20050731175946.GA8511@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

Christoph Hellwig wrote:
> On Sun, Jul 31, 2005 at 07:54:59PM +0200, Stefan Richter wrote:
>>Well, the LLD can _try_ it, but it may go horribly wrong.
> 
> It seems to work nicely for everyone but sbp2..

Sure. There is be probably something in sbp2 or nodemgr that leads
to a deadlock, although the end of the road as we can see it is
located in the scsi highlevel.
-- 
Stefan Richter
-=====-=-=-= -=== =====
http://arcgraph.de/sr/
