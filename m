From: Andi Kleen <andi@firstfloor.org>
Subject: Re: sata & scsi suggestion for make menuconfig
Date: Sat, 8 Sep 2007 20:13:09 +0200
Message-ID: <20070908181309.GA8647@one.firstfloor.org>
References: <20070907124800.GP16806@vanheusden.com> <p73fy1p9m57.fsf@bingen.suse.de> <20070908095008.08eb4930.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:39112 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbXIHSNM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Sep 2007 14:13:12 -0400
Content-Disposition: inline
In-Reply-To: <20070908095008.08eb4930.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> I'd say that someone needs to use a vendor kernel, or at least
> begin with a vendor .config file...

Vendor kernels tend to compile forever and require initrds. For 
just testing a kernel quickly compiling only a few drivers in
is much more convenient.

Also when you've been using CONFIG_IDE before it is not completely
obvious you need BLK_SD for your hard disk.

-Andi
