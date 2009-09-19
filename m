From: Stanislaw Gruszka <stf_xl@wp.pl>
Subject: Re: [Scst-devel] [ANNOUNCE]: Support of QLogic Fibre Channel 4/8Gb
	(24xx/25xx) HBA's added in target driver for SCST qla2x00t
Date: Sat, 19 Sep 2009 21:33:16 +0200
Message-ID: <20090919193315.GA2168@r2bh72.net.upc.cz>
References: <4AB29974.70602@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.wp.pl ([212.77.101.1]:58866 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752015AbZISSFu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Sep 2009 14:05:50 -0400
Content-Disposition: inline
In-Reply-To: <4AB29974.70602@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>

On Fri, Sep 18, 2009 at 12:17:56AM +0400, Vladislav Bolkhovitin wrote:
> Although there is a current QLogic target driver qla_isp, this driver 
> has the key advantage that it was designed to be as simple as possible. 
> As the result, this driver is a lot smaller, cleaner and mainline Linux 
> kernel ready. After some cosmetic cleanups it's going to be pushed for 
> the in-kernel inclusion together other SCST patches.

Great, this makes qla_isp obsolete. I'm very happy with that, I guess
Matthew too.

Cheers
Stanislaw
