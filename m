From: "Scott M. Ferris" <sferris@acm.org>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl for sysfs take
 2
Date: Tue, 7 Sep 2004 14:19:18 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040907191918.C045E76C56@isis.visi.com>
References: <1094571319.1716.108.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from conn.mc.mpls.visi.com ([208.42.156.2]:40642 "EHLO
	conn.mc.mpls.visi.com") by vger.kernel.org with ESMTP
	id S268503AbUIGTTV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 15:19:21 -0400
In-Reply-To: <1094571319.1716.108.camel@mulgrave> from James Bottomley at "Sep
 7, 2004 10:43:00 am"
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Christie <mikenc@us.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>, Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, iscsi -devel <linux-iscsi-devel@lists.sourceforge.net>, David Wysochanski <davidw@netapp.com>, "Surekha.PC" <surekhap@cisco.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
>
> A host is the analogue of a bus.  

That's not a very helpful analogy, since only SPI and FC-AL resemble a
bus, and all of the newer SCSI transports are switched fabrics.

> In iSCSI that's really the other end point.  Using abstractions
> incorrectly (like a single host for the entire iSCSI system) is
> bound to end up with problems due to the concept mismatch.

I have trouble understanding your viewpoint.  Your answers to the
following questions will hopefully clear things up.

Do you think Linux hosts should be used in a similar way by all
switched SCSI transports (e.g. FC-SW, iSCSI, SAS)?  If not, why not?

Do you think switched SCSI transports should allocate one Linux host
for each I_T nexus?

Do you think switched SCSI transports should allocate one Linux host
for each (SAM-2 or SAM-3) SCSI initiator port?

Do you think switched SCSI transports should allocate one Linux host
for each (SAM-2 or SAM-3) SCSI initiator device?

-- 
Scott M. Ferris,
sferris@acm.org 
