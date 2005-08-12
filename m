From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: hwo to adjust interrupt?
Date: Fri, 12 Aug 2005 09:59:53 -0700
Message-ID: <OF830E5E11.DB8332D4-ON8825705B.005D2AA9-8825705B.005D61FD@us.ibm.com>
References: <1123830899.3218.15.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46019 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750707AbVHLQ7x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2005 12:59:53 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j7CGxq3a025283
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2005 12:59:52 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7CGxqWG252116
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2005 12:59:52 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j7CGxqA6023376
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2005 12:59:52 -0400
In-Reply-To: <1123830899.3218.15.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, mingz@ele.uri.edu

>(Not that it's a big problem, sharing irqs on a pci system isn't too big
>a deal)

Just how big a deal is it?  How much extra work does Linux have to do for 
each interrupt?

