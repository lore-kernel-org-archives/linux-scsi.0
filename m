From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Kernel panic - Ththththaats all folks
Date: Fri, 05 Sep 2003 22:38:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1062797882.689.34.camel@dhcp23.swansea.linux.org.uk>
References: <20030905145235.19968.qmail@web21109.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc1-cwma1-5-cust4.swan.cable.ntl.com ([80.5.120.4]:29919 "EHLO
	dhcp23.swansea.linux.org.uk") by vger.kernel.org with ESMTP
	id S264829AbTIEVjC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Sep 2003 17:39:02 -0400
In-Reply-To: <20030905145235.19968.qmail@web21109.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Sulamita Garcia <sulagarcia@yahoo.com.br>
Cc: linux-scsi@vger.kernel.org

On Gwe, 2003-09-05 at 15:52, Sulamita Garcia wrote:
> > Problems with HPT's partially binary module should
> > be directed to
> > highpoint not to this list. Looking at the trace its
> > almost certainly
> > a bug in their alternative software raid driver.
> 
> But the module who did the panic was scsi(the panic
> error is in scsi_merge). I just want know why.

Ask hpt. Only they have the code for both parts. The panic 
indicates which bit of code spotted a problem not where the bug is

