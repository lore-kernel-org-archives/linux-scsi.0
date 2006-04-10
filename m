From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] deinline some functions in aic7xxx drivers, save 80k
 of text
Date: Mon, 10 Apr 2006 11:40:21 +0200
Message-ID: <443A2805.6000806@s5r6.in-berlin.de>
References: <200604100844.12151.vda@ilport.com.ua> <200604100903.35431.eike-kernel@sf-tec.de> <200604101015.36869.vda@ilport.com.ua> <200604100919.23244.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:13768 "EHLO
	hp3.statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S1751093AbWDJJl1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Apr 2006 05:41:27 -0400
In-Reply-To: <200604100919.23244.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Denis Vlasenko <vda@ilport.com.ua>, SCSI List <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, gibbs@scsiguy.com

Rolf Eike Beer wrote:
> Denis Vlasenko wrote:
>> I am leaving it up to maintainer to decide. After all, the driver
>> is for multiple OSes, other OS may lack mdelay().
> 
> The comment says about multiple milliseconds sleeps which just don't happen.

Given what ah{c,d}_delay are (OS dependent wrappers) and how they are
used (definitely not for multi-msec delays), they should just be changed
into a #define ah{c,d}_delay(us) udelay(us) or into void inline
ah{c,d}_delay(long us) {udelay(us);}.
-- 
Stefan Richter
-=====-=-==- -=-- -=-=-
http://arcgraph.de/sr/
