From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Thu, 6 Nov 2003 11:14:08 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031106111407.A16207@infradead.org>
References: <005801c3a44a$5847c6e0$8f074d0a@apac.cisco.com> <Pine.LNX.4.10.10311060302400.28485-100000@master.linux-ide.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:52240 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263517AbTKFLOK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2003 06:14:10 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.10.10311060302400.28485-100000@master.linux-ide.org>; from andre@linux-ide.org on Thu, Nov 06, 2003 at 03:10:59AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Andre Hedrick <andre@linux-ide.org>
Cc: "Sachin Mhatre (smhatre)" <smhatre@cisco.com>, 'Christoph Hellwig' <hch@infradead.org>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Thu, Nov 06, 2003 at 03:10:59AM -0800, Andre Hedrick wrote:
> 
> It needs to be handled in the iSCSI driver.
> Extending the operation to the entire midlayer will cause great grief to
> all the HBA's which do not even support the abridged version of SBC call.
> Some support only a subset of the subset of SCSI commands.  Until all
> HBA code has a means to report a positive list of commands supported, only
> exception callers in the local real/virtual HBA appears doable.

in the midlayer != enabled unconditionally.  We just have much better
infrastructure for this than a LLDD.

