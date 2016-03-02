From: Varun Prakash <varun@chelsio.com>
Subject: Re: [RFC 13/34] iscsi-target: add new transport type
Date: Wed, 2 Mar 2016 17:22:05 +0530
Message-ID: <20160302115204.GA1755@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
 <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
 <20160301144848.GB9738@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:17313 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbcCBLwt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2016 06:52:49 -0500
Content-Disposition: inline
In-Reply-To: <20160301144848.GB9738@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "roland@kernel.org" <roland@kernel.org>, SWise OGC <swise@opengridcomputing.com>, Indranil Choudhury <indranil@chelsio.com>, Karen Xie <kxie@chelsio.com>, Hariprasad S <hariprasad@chelsio.com>

On Tue, Mar 01, 2016 at 08:18:48PM +0530, Christoph Hellwig wrote:
> This really looks like an odd interface.  I think everyone will
> be much happpier in the long run if you do a generic offload interface
> instead of special casing each possible driver.

Common offload transport type is a better option, but we
have to do many changes in iscsi-target to 
support multiple offload drivers simultaneously.
