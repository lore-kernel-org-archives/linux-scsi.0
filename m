From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Fri, 21 Oct 2005 11:06:25 +0200
Message-ID: <1129885586.2786.12.camel@laptopd505.fenrus.org>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com>
	 <20051020160155.GA14296@lst.de> <4357CB03.4020400@adaptec.com>
	 <20051020170330.GA16458@lst.de>  <4357F7DE.7050004@adaptec.com>
	 <1129852879.30258.137.camel@bluto.andrew>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:31697 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932560AbVJUJGh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Oct 2005 05:06:37 -0400
In-Reply-To: <1129852879.30258.137.camel@bluto.andrew>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.patterson@hp.com
Cc: linux-scsi@vger.kernel.org, jejb@steeleye.com, "Moore, Eric Dean" <Eric.Moore@lsil.com>, Christoph Hellwig <hch@lst.de>, Luben Tuikov <luben_tuikov@adaptec.com>

On Thu, 2005-10-20 at 18:01 -0600, Andrew Patterson wrote:

> Yes, CSMI should have had more Linux input when it was developed.  The
> no-new IOCTL policy certainly came as a surprise to the authors. Still,
> there doesn't seem to be any other usable cross-platform interface that
> is acceptable to the linux community (or at least to Christoph)'s corner
> of it).  My personal preference is to hide this stuff in a library, so
> the kernel implementation is hidden. But even a library needs an
> underlying kernel implementation.


but why didn't CSMI specify the library interface then? If it did that,
then none of the "ioctls are deprecated for 3 years now" would have come
as a surprise. Or rather, it maybe would have, but it wouldn't have
mattered to the management app.


