From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Fri, 21 Oct 2005 14:57:54 -0400
Message-ID: <43593A32.7040802@adaptec.com>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com>	 <20051020160155.GA14296@lst.de> <4357CB03.4020400@adaptec.com>	 <20051020170330.GA16458@lst.de>  <4357F7DE.7050004@adaptec.com>	 <1129852879.30258.137.camel@bluto.andrew>	 <1129885586.2786.12.camel@laptopd505.fenrus.org> <1129914336.30258.179.camel@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:64910 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S965093AbVJUS6I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Oct 2005 14:58:08 -0400
In-Reply-To: <1129914336.30258.179.camel@bluto.andrew>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.patterson@hp.com
Cc: Arjan van de Ven <arjan@infradead.org>, linux-scsi@vger.kernel.org, jejb@steeleye.com, "Moore, Eric Dean" <Eric.Moore@lsil.com>, Christoph Hellwig <hch@lst.de>

On 10/21/05 13:05, Andrew Patterson wrote:
>>but why didn't CSMI specify the library interface then? If it did that,
>>then none of the "ioctls are deprecated for 3 years now" would have come
>>as a surprise. Or rather, it maybe would have, but it wouldn't have
>>mattered to the management app.
> 
> I asked one of the authors, Steve Fairchild, about this.  He said that
> they had had a bad experience with HBAAPI, the FC library.  They had a
> lot of problems with vendors keeping the library up to date, multiple
> vendors shipping multiple incompatible versions, etc.  I wasn't entirely
> convinced, since they seem to have just replaced one set of problems for
> another.

The user app would read the SDI major and minor from SDI_GET_DRIVER_INFO
and then know which spec to use.

After that just sending bytes of data (forming units) one after the other
(as in "smp_portal") would suffice for 32/64 bit (similarly to SG).

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
