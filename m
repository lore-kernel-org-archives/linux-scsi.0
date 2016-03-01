From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 24/34] iscsi-target: validate conn operational parameters
Date: Tue, 1 Mar 2016 07:03:18 -0800
Message-ID: <20160301150318.GJ9738@infradead.org>
References: <cover.1455467089.git.varun@chelsio.com>
 <940698fdb1ca47d8c392fa687f971842d215d083.1455467089.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47452 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbcCAPDT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2016 10:03:19 -0500
Content-Disposition: inline
In-Reply-To: <940698fdb1ca47d8c392fa687f971842d215d083.1455467089.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com

On Sun, Feb 14, 2016 at 11:15:31PM +0530, Varun Prakash wrote:
> call validate params function if registered
> by transport driver before starting negotiation,
> so that transport driver can validate and update
> the value of parameters.

Should go together with the introduction of the method.
