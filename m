From: Christoph Hellwig <hch@infradead.org>
Subject: Re: LIO performance Issue
Date: Fri, 16 Sep 2011 09:51:26 -0400
Message-ID: <20110916135126.GA27583@infradead.org>
References: <EF8AD1CD95CD1E4DBF423FF61CCFC5A9E4E199860C@NDA-HCLT-EVS04.HCLT.CORP.HCL.IN>
 <1316031025.12820.95.camel@haakon2.linux-iscsi.org>
 <4E72564E.8000406@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47696
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754623Ab1IPNve (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2011 09:51:34 -0400
Content-Disposition: inline
In-Reply-To: <4E72564E.8000406@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Shankar <ravi.v.shankar@oracle.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Abhilash Sankar - ERS, HCL Tech" <Abhilash.S@hcl.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-iscsi-target-dev@googlegroups.com" <linux-iscsi-target-dev@googlegroups.com>, "Yuvarani C - ERS , HCLTech" <yuvaranic@hcl.com>, "Bagavathy Kumar Mahendran - ERS, HCL Tech" <bagavathykumar.m@hcl.com>, target-devel <target-devel@vger.kernel.org>

On Thu, Sep 15, 2011 at 12:47:26PM -0700, Ravi Shankar wrote:
> Another area to consider improvement is how SCSI Target Data phase
> are handled.
> The target framework should split SCSI data phases into multiple
> smaller IO to increase
> performance. In other work instead of synchronous data phase it need
> to be asynchronous.

There isn't any good in-kernel interface to do asynchronous file I/O.
If you use the iblock backend you'll get asynchronous behaviour.

