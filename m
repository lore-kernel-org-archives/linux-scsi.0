From: Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: [patch 6/7] ps3: ROM Storage Driver
Date: Wed, 30 May 2007 10:18:35 -0700
Message-ID: <465DB1EB.5010603@am.sony.com>
References: <20070525083607.784351000@sonycom.com>	<20070525083632.677742000@sonycom.com> <20070529104948.GC29351@lst.de>	<Pine.LNX.4.62.0705291308280.7698@pademelon.sonytel.be>	<20070530101348.GD24586@lst.de> <1180525555.19517.268.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:38701 "EHLO
	outbound6-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752126AbXE3Rhm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:37:42 -0400
In-Reply-To: <1180525555.19517.268.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christoph Hellwig <hch@lst.de>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Wed, 2007-05-30 at 12:13 +0200, Christoph Hellwig wrote:
>> 
>> For any sane hypervisor or hardware the copy should be worth
>> than that.  Then again a sane hardware or hypervisor would support
>> SG requests..
> 
> Agreed... Sony should fix that, it's a bit ridiculous.

Yes, if only to put an end to seeing this kind of comment over 
and over again.

-Geoff

