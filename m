From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH: (as284c) Add BLIST_INQUIRY_36 to all USB blacklist entries
Date: Thu, 26 Aug 2004 20:11:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040826201128.A23103@infradead.org>
References: <Pine.LNX.4.44L0.0408261149150.1089-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:30474 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S269418AbUHZTLj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 15:11:39 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0408261149150.1089-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Thu, Aug 26, 2004 at 11:53:45AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, Aug 26, 2004 at 11:53:45AM -0400, Alan Stern wrote:
> James:
> 
> I submitted this patch earlier but received no response.
> 
> This patch adds the BLIST_INQUIRY_36 flag to all the SCSI blacklist

Maybe instead of adding gazillions of blacklists for different inquiry
lengthes we should just add an max_inquiry_length field to scsi_device
that can be set in slave_alloc?

