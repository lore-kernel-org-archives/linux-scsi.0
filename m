From: Grant Grundler <iod00d@hp.com>
Subject: Re: convert 520 byte sector disk to 512 byte sector?
Date: Tue, 10 Jun 2003 10:24:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030610172403.GG6384@cup.hp.com>
References: <20030609174647.GB29808@cup.hp.com> <20030609122907.A16169@beaverton.ibm.com> <20030609223905.GH29808@cup.hp.com> <3EE53A34.7070503@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel12.hp.com ([156.153.255.237]:49070 "EHLO palrel12.hp.com")
	by vger.kernel.org with ESMTP id S263590AbTFJRK2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2003 13:10:28 -0400
Content-Disposition: inline
In-Reply-To: <3EE53A34.7070503@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

On Tue, Jun 10, 2003 at 11:53:56AM +1000, Douglas Gilbert wrote:
> www.seagate.com have a tool called "seatool" that may
> do the trick for you.

Doug,
thanks - but last time I checked, it's an x86 binary only driver.
I guess I could try it anyway and see if the IOCTLs have
32-bit compat support in ia64 kernel.

thanks,
grant
