From: Varun Prakash <varun@chelsio.com>
Subject: Re: [RFC 15/34] iscsi-target: export symbols from iscsi_target.c
Date: Wed, 2 Mar 2016 17:37:49 +0530
Message-ID: <20160302120747.GC1755@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
 <a52145ef75173d293b229cab3e3eba08528aefdc.1455467089.git.varun@chelsio.com>
 <20160301144948.GD9738@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:44360 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbcCBMIW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2016 07:08:22 -0500
Content-Disposition: inline
In-Reply-To: <20160301144948.GD9738@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "roland@kernel.org" <roland@kernel.org>, SWise OGC <swise@opengridcomputing.com>, Indranil Choudhury <indranil@chelsio.com>, Karen Xie <kxie@chelsio.com>, Hariprasad S <hariprasad@chelsio.com>

On Tue, Mar 01, 2016 at 08:19:48PM +0530, Christoph Hellwig wrote:
> On Sun, Feb 14, 2016 at 11:12:09PM +0530, Varun Prakash wrote:
> > export symbols from iscsi_target.c for
> > ISCSI_TCP_CXGB4 transport driver.
> 
> What exactly is the reason for the split between this and the previous
> patch?

To avoid a single big patch I created two separate patch,
also there are large number of functions exported from iscsi_target.c
as compared to other files.
