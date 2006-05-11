From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: FIXED: Bogus st failures from qla1280 timeouts
Date: Thu, 11 May 2006 22:04:03 +0300 (EEST)
Message-ID: <Pine.LNX.4.63.0605112155510.4698@kai.makisara.local>
References: <F3598542BAC24B4783B7A440D45522FF04050577@usahm236.amer.corp.eds.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep30-0.kolumbus.fi ([193.229.0.32]:8043 "EHLO
	fep30-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1750713AbWEKTEG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 May 2006 15:04:06 -0400
In-Reply-To: <F3598542BAC24B4783B7A440D45522FF04050577@usahm236.amer.corp.eds.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bailey, Scott" <scott.bailey@eds.com>
Cc: Jes.Sorensen@cern.ch, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Wed, 10 May 2006, Bailey, Scott wrote:

> Absent more informed guidance, I went nuts and increased the timeout
> settings in qla1280.c from 30 seconds to 15 minutes. My tape drive works
> great now. The attached Debian bug report (bug 366730) summarizes the
> situation. I don't know if this is something suitable for inclusion to
> the kernel "as-is" or if I am overlooking some horrible side-effect that
> will bite me down the road.
> 
> Any feedback?
> 
Good. This solves your practical problem but raises one (theoretic?) 
question: why is the qla1280 driver even trying to enforce device level 
timeouts? This should be left to the upper layers.

The default timeouts in the st driver were increased several times 
according to reports from users. The 900 second timeout in your patch may 
be too short in some cases but it probably is wise not to increase it too 
much unless someone really needs that.

-- 
Kai
