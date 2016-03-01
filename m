From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 21/34] iscsi-target: release transport driver resources
Date: Tue, 1 Mar 2016 06:59:53 -0800
Message-ID: <20160301145953.GG9738@infradead.org>
References: <cover.1455467089.git.varun@chelsio.com>
 <26d1bde8e55db6d2f77a354b379bec78bb7b7322.1455467089.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <26d1bde8e55db6d2f77a354b379bec78bb7b7322.1455467089.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com
List-Id: linux-scsi@vger.kernel.org

On Sun, Feb 14, 2016 at 11:12:15PM +0530, Varun Prakash wrote:
> transport driver may allocate resources for an
> iSCSI cmd, to free that resources iscsi target
> must call release function registered by transport
> driver.
> 
> ISCSI_TCP_CXGB4 frees DDP resource associated
> with a WRITE cmd in the callback function.

This should go with the patch introducing the method.
