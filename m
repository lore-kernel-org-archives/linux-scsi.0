From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Kernel panic - Ththththaats all folks
Date: Fri, 05 Sep 2003 15:37:46 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1062772665.32436.4.camel@dhcp23.swansea.linux.org.uk>
References: <20030905140100.53464.qmail@web21106.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc1-cwma1-5-cust4.swan.cable.ntl.com ([80.5.120.4]:27870 "EHLO
	dhcp23.swansea.linux.org.uk") by vger.kernel.org with ESMTP
	id S263061AbTIEOiz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Sep 2003 10:38:55 -0400
In-Reply-To: <20030905140100.53464.qmail@web21106.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Sulamita Garcia <sulagarcia@yahoo.com.br>
Cc: linux-scsi@vger.kernel.org

On Gwe, 2003-09-05 at 15:01, Sulamita Garcia wrote:
> instalation default, and rebuild module from source
> because kernel module didn't work. Now I have a Raid 0
> by hardware

Problems with HPT's partially binary module should be directed to
highpoint not to this list. Looking at the trace its almost certainly
a bug in their alternative software raid driver.

Alan
