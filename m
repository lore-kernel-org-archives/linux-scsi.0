From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: block/bsg.c
Date: Thu, 19 Jul 2007 08:18:21 +0900
Message-ID: <20070719081821U.fujita.tomonori@lab.ntt.co.jp>
References: <20070718092130V.tomof@acm.org>
	<1184766854.3464.4.camel@localhost.localdomain>
	<1184768624.3464.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:42559 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbXGRXSn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2007 19:18:43 -0400
In-Reply-To: <1184768624.3464.15.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: tomof@acm.org, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: block/bsg.c
Date: Wed, 18 Jul 2007 09:23:44 -0500

> On Wed, 2007-07-18 at 08:54 -0500, James Bottomley wrote:
> > You're welcome ... although there's still a problem for modular builds.
> > This is what my /sys/class/bsg looks like:
> 
> Sorry, lets see if I can get the paste to work this time:
> 
> jejb@hobholes> ls /sys/class/bsg/
> 0:0:1:0/  sdb/

Surely, confusing. Let's dump the if and use the sdev name for now.

Thanks,
