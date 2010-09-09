From: =?unknown-8bit?B?SvxyZ2VuIEUu?= Fischer <fischer@norbit.de>
Subject: Re: Why is AHA152X_CS !64BIT?
Date: Thu, 9 Sep 2010 22:01:01 +0200
Message-ID: <20100909200101.GA19568@linux-buechse.de>
References: <4C72D310.4040004@suse.cz>
 <4C7B924D.6030703@panasas.com>
 <201009071712.54867.konrad@darnok.org>
 <4C86B1A4.8030308@oracle.com>
 <4C86B320.8090709@oracle.com>
 <1283897409.22844.7.camel@mulgrave.site>
 <4C86B9A6.2050808@suse.cz>
Reply-To: fischer@linux-buechse.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:49285 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab0IIUBG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2010 16:01:06 -0400
Received: from elrond.intern.linux-buechse.de (fischer@localhost [127.0.0.1])
	by linux-buechse.de (8.14.3/8.14.3/Debian-9.2) with ESMTP id o89K12Gt020053
	for <linux-scsi@vger.kernel.org>; Thu, 9 Sep 2010 22:01:02 +0200
Received: (from fischer@localhost)
	by elrond.intern.linux-buechse.de (8.14.3/8.14.3/Submit) id o89K11ur020052
	for linux-scsi@vger.kernel.org; Thu, 9 Sep 2010 22:01:01 +0200
Content-Disposition: inline
In-Reply-To: <4C86B9A6.2050808@suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi Jiri,

On Wed, Sep 08, 2010 at 00:16:06 +0200, Jiri Slaby wrote:
> As I wrote few minutes ago, there is only one which is in print. And I
> cannot find anybody fixing anything similar since 2.1.
 
> So can we enable it on 64-bit when we have two reports it works on
> 64-bit? (Is it still maintained? MAINTAINERS says so...)

For the maintainance: My ISA machine is defunct, but I still have a
PCMCIA card to test and debug it needed - although no 64bit machine with
a PCMCIA slot.

I suppose the hardware is so hardly used nowadays, that there simply
hasn't been any need for aha152x specific changes (or debugging) for
years.  And all the interface updates were done by whoever changed the
generic interface and I eventually ceased to follow.

So I guess the maintainance state should be changed to "Odd fixes" at
best.


Juergen
