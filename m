From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Why is AHA152X_CS !64BIT?
Date: Wed, 8 Sep 2010 08:05:57 +0200
Message-ID: <20100908080557.511d307b@basil.nowhere.org>
References: <4C72D310.4040004@suse.cz>
	<4C7B924D.6030703@panasas.com>
	<201009071712.54867.konrad@darnok.org>
	<4C86B1A4.8030308@oracle.com>
	<4C86B320.8090709@oracle.com>
	<4C86B860.1070105@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:40030 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757147Ab0IHGGD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2010 02:06:03 -0400
In-Reply-To: <4C86B860.1070105@suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, fischer@linux-buechse.de, linux-scsi@vger.kernel.org


> 
> Hmm, the changelog says:
> The warning I saw was actually for the PCMCIA aha152x driver.
> 
> which I think are compiler warnings. But I see only one emitted by the
> compiler and it is in a debug print.


Don't remember the exact warning, but I was rather trigger happy
on getting rid of all these ancient unmaintained drivers on 64bit 
back then.

In hindsight it was the right thing to do -- their userbase
seems to be near zero and there were little to no complains 
about it ever.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
