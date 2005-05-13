From: Christoph Hellwig <hch@infradead.org>
Subject: Re: several messages
Date: Fri, 13 May 2005 09:12:30 +0100
Message-ID: <20050513081230.GA32546@infradead.org>
References: <1416215015.20050504193114@dns.toxicfilms.tv> <1115236116.7761.19.camel@dhollis-lnx.sunera.com> <1104082357.20050504231722@dns.toxicfilms.tv> <1115305794.3071.5.camel@dhollis-lnx.sunera.com> <20050507150538.GA800@favonius> <Pine.LNX.4.60.0505102352430.9008@poirot.grange> <4281C8A3.20804@vlnb.net> <Pine.LNX.4.60.0505112309430.8122@poirot.grange> <1115864176.5513.37.camel@localhost.localdomain> <1115922732.25161.143.camel@beastie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:7132 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262295AbVEMIMq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2005 04:12:46 -0400
Content-Disposition: inline
In-Reply-To: <1115922732.25161.143.camel@beastie>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Yusupov <dmitry_yus@yahoo.com>
Cc: mingz@ele.uri.edu, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Vladislav Bolkhovitin <vst@vlnb.net>, iet-dev <iscsitarget-devel@lists.sourceforge.net>, linux-scsi <linux-scsi@vger.kernel.org>, Sander <sander@humilis.net>, David Hollis <dhollis@davehollis.com>, Maciej Soltysiak <solt2@dns.toxicfilms.tv>, linux-kernel <linux-kernel@vger.kernel.org>

On Thu, May 12, 2005 at 11:32:12AM -0700, Dmitry Yusupov wrote:
> On Wed, 2005-05-11 at 22:16 -0400, Ming Zhang wrote:
> > iscsi is scsi over ip.
> 
> correction. iSCSI today has RFC at least for two transports - TCP/IP and
> iSER/RDMA(in finalized progress) with RDMA over Infiniband or RNIC. And
> I think people start writing initial draft for SCTP/IP transport...
> 
> >From this perspective, iSCSI certainly more advanced and matured
> comparing to NBD variations. 

It's for certainly much more complicated (in marketing speak that's usually
called advanced) but far less mature.

If you want network storage to just work use nbd.
