From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [2.5.70] aic7xxx patch
Date: Sun, 01 Jun 2003 09:28:05 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2770950000.1054481285@aslan.scsiguy.com>
References: <20030601133855.GA1035@bazooka.saturnus.vein.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aslan.scsiguy.com ([63.229.232.106]:1028 "EHLO
	aslan.scsiguy.com") by vger.kernel.org with ESMTP id S264643AbTFAPP7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Jun 2003 11:15:59 -0400
In-Reply-To: <20030601133855.GA1035@bazooka.saturnus.vein.hu>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Banai Zoltan <bazooka@vekoll.vein.hu>, linux-scsi@vger.kernel.org

> Hi!
> 
> I've got a complie error in aic7xxx_osm.c, witch seems to be sloved by
> the following  patch. (please check carefully!)

Your patch is incorrect.  0x100000000 should be promoted to unsigned
long long.  In the latest version of the driver, this code is simply
removed as Linux guarantees that segments will not cross a 4GB boundary.

--
Justin

