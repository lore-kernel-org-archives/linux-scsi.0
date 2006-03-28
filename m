From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aic94xx: move entirely over to correct transport class formulation
Date: Tue, 28 Mar 2006 16:07:09 +0100
Message-ID: <20060328150709.GA17420@infradead.org>
References: <1143499534.3334.33.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:59565 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750802AbWC1PHL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 10:07:11 -0500
Content-Disposition: inline
In-Reply-To: <1143499534.3334.33.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Mar 27, 2006 at 04:45:34PM -0600, James Bottomley wrote:
> This patch moves the sas class over to being a transport class (the sas
> event functions now become transport functions) and the aic94xx now sets
> everything up in the standard transport class way.
> 
> I've also fixed the multiple instance problem and verified that two
> cards in the same box work.

Adding an own transport class for aic94xx seems very wrong.  It should
attach to the standard sas one and use the sas-class based code as
some kind of libsas.

