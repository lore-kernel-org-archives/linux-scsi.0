From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [bk patches] move scsi headers
Date: Tue, 27 May 2003 06:35:13 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030527063513.A2357@infradead.org>
References: <20030527034239.GA16376@gtf.org> <20030527061444.A1905@infradead.org> <3ED2F568.7060501@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([195.224.96.167]:35079 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263528AbTE0FWC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2003 01:22:02 -0400
Content-Disposition: inline
In-Reply-To: <3ED2F568.7060501@pobox.com>; from jgarzik@pobox.com on Tue, May 27, 2003 at 01:19:36AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Tue, May 27, 2003 at 01:19:36AM -0400, Jeff Garzik wrote:
>This is too ambitious this close to 2.6-pre,

No, it's not.  Eihet we do it properly or not at all.  Having to use
different headers for 2.4,2.6and 2.7/2.8 is just extremly stupid.

Also we have more intrusive stuff in scsi pending, 2.6.pre or not.

