From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.3
Date: Mon, 29 Dec 2003 13:23:18 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FF09B46.5070902@us.ibm.com>
References: <03121719101402.28899@naveenb-lnx.cisco.com> <20031228202519.A22856@infradead.org> <03122920412702.20911@naveenb-lnx.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:641 "EHLO e31.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S264277AbTL2VYA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Dec 2003 16:24:00 -0500
In-Reply-To: <03122920412702.20911@naveenb-lnx.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: naveenb@cisco.com
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org


>>  - as Mike Christie you're doing multipathing in your driver.  We don't
>>    want vendor-specific multipathing code in scsi-drivers but instead
>>    encurage using md or dm multipathing.
>>
> 
> 
> linux-iscsi driver 4.0.0.2 is not doing multipathing instead it provides 
> infrastructure to do multipathing and encourages other applications/drivers 
> like md  to do multipathing.
> 
>

I think Christoph may have meant to write "Failover" above.

mike

