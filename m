From: Christoph Hellwig <hch@infradead.org>
Subject: Re: T10-PI: Getting failed tag info
Date: Tue, 30 Dec 2014 04:15:42 -0800
Message-ID: <20141230121542.GF32187@infradead.org>
References: <54892468.5060300@vlnb.net>
 <yq1r3w5blys.fsf@sermon.lab.mkp.net>
 <20141215081857.GA24067@infradead.org>
 <yq1zjao8lsc.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37938 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaL3MPr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Dec 2014 07:15:47 -0500
Content-Disposition: inline
In-Reply-To: <yq1zjao8lsc.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org

On Mon, Dec 15, 2014 at 07:45:39PM -0500, Martin K. Petersen wrote:
> >>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:
> 
> Christoph> I really don't like adding new errno codes for all these.
> 
> This was mainly done to accommodate Darrick's work on aio extensions. If
> these errors were forever trapped inside the kernel I would agree with
> you but the plan is to make this generally applicable.

But those extensions require new structures to pass in the PI info
anyway..

