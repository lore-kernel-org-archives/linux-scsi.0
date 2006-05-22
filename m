From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: 2.6.14 regression: aic7xxx hangs on boot
Date: Mon, 22 May 2006 09:36:39 -0500
Message-ID: <1148308599.3320.26.camel@mulgrave.il.steeleye.com>
References: <44461FB5.8060705@gentoo.org>
	 <1145454585.3465.5.camel@mulgrave.il.steeleye.com>
	 <444658BE.5080309@gentoo.org>
	 <1145462527.6183.5.camel@mulgrave.il.steeleye.com>
	 <4471CD38.8010400@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:53156 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750868AbWEVOgy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 May 2006 10:36:54 -0400
In-Reply-To: <4471CD38.8010400@gentoo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Drake <dsd@gentoo.org>
Cc: gibbs@scsiguy.com, linux-scsi@vger.kernel.org

On Mon, 2006-05-22 at 15:39 +0100, Daniel Drake wrote:
> Sorry for the delay, the user has now provided some serial console logs. 
> Actually there is some good news: somewhere between 2.6.17-rc2 and 
> 2.6.17-rc4, the situation has improved, errors do appear during boot but 
> the system does reach a login prompt now (previously it was looping 
> seemingly forever).

That's identical to this, isn't it?

http://marc.theaimsgroup.com/?l=linux-scsi&m=114820550424513

James


