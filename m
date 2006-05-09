From: Jes Sorensen <jes@sgi.com>
Subject: Re: Bogus st failures from qla1280 timeouts?
Date: 09 May 2006 10:16:46 -0400
Message-ID: <yq08xpbqo4x.fsf@jaguar.mkp.net>
References: <F3598542BAC24B4783B7A440D45522FF04050571@usahm236.amer.corp.eds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vanessarodrigues.com ([192.139.46.150]:30403 "EHLO
	jaguar.mkp.net") by vger.kernel.org with ESMTP id S1750880AbWEIOQt
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 May 2006 10:16:49 -0400
In-Reply-To: <F3598542BAC24B4783B7A440D45522FF04050571@usahm236.amer.corp.eds.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bailey, Scott" <scott.bailey@eds.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

>>>>> "Scott" == Bailey, Scott <scott.bailey@eds.com> writes:

Scott> I've been worrying around the edges of this problem for months
Scott> without really feeling that I understand it but I have formed
Scott> enough suspicions to make this quasi-informed plea for
Scott> help... :-)

Scott> I manage an Alphaserver 4100/466 with 3 processors running
Scott> Debian testing/unstable (presently with kernel built from
Scott> Debian's linux-source-2.6.16-12 package). It is equipped with 3
Scott> KZPBA (single-ended) SCSI controllers, for which I use the
Scott> qla1280 driver with ISP1040 support enabled. (I was never so
Scott> happy as when this support was introduced and I could say
Scott> good-bye to kernel 2.4 and the sort-of-not-really-supported
Scott> Feral driver.)

Scott,

I think there are some problems with the 1040 support in general, at
least on Alpha as you're not the only one who have seen problems
there. Christoph did the 1020/1040 support so I am going to blame him
for it :) I have zero knowledge about those cards so there isn't much
I can do to help.

Regards,
Jes
