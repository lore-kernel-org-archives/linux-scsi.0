From: brace <brace@pmcs.com>
Subject: RE: [PATCH 00/13] hpsa update
Date: Mon, 24 Nov 2014 19:22:46 +0000
Message-ID: <3DDAC9D31C8A6A48BA9003A158488F44386498@BBYEXM01.pmc-sierra.internal>
References: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
 <20141120155520.GC26189@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:49061 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643AbaKXTnU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 14:43:20 -0500
In-Reply-To: <20141120155520.GC26189@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Don Brace <Don.Brace@pmcs.com>
Cc: "webb.scales@hp.com" <webb.scales@hp.com>, "james.bottomley@parallels.com" <james.bottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, November 20, 2014 9:55 AM
> To: Don Brace
> Cc: hch@infradead.org; webb.scales@hp.com;
> james.bottomley@parallels.com; brace; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 00/13] hpsa update
> 
> I've applied all patches to drivers-for-3.19.
> 
> If you could do me two favours:
> 
>  - please look into sparse endianess warnings.  This series introduces
>    a few new ones, but given that the area around it was full of it
>    I didn't pull it for that for now.
>  - please review the various hpsa fixes Tomas Henzl sent over the last
>    few weeks.
> 
> Thanks,
> 	Christoph

I created a patch for the extra sparse warnings and I have it in for a local review.
I will get it up soon. Most of the people in my area are off this week. 

