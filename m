From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: 2.6.5-rc1 SCSI + st regressions (was: Linux 2.6.5-rc1)
Date: Wed, 17 Mar 2004 22:43:29 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040317214329.GA5135@merlin.emma.line.org>
References: <Pine.LNX.4.58.0403152154070.19853@ppc970.osdl.org> <20040316211203.GA3679@merlin.emma.line.org> <20040316211700.GA25059@parcelfarce.linux.theplanet.co.uk> <20040316215659.GA3861@merlin.emma.line.org> <Pine.LNX.4.58.0403172145420.1093@kai.makisara.local> <Pine.LNX.4.58.0403172312410.1093@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:31956 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S262099AbUCQVne (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2004 16:43:34 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0403172312410.1093@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Matthias Andree <ma+lscsi@dt.e-technik.uni-dortmund.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>

On Wed, 17 Mar 2004, Kai Makisara wrote:

> The patch at the end of this message removes the dependency on the kobj 
> name being set. It also tries to once more restore the naming that is 
> defined in devices.txt. The patch is against 2.6.5-rc1-bk2 and it seems to 
> work correctly in my tests.

Your patch fixes my problem. Thank you.

st0* and st1* devices are registered, the devices are properly attached,
mtst -f /dev/nst1 status works (same for nst0).

-- 
Matthias Andree

Encrypt your mail: my GnuPG key ID is 0x052E7D95
