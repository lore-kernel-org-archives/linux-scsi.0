From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH ] fusion SAS support (mptsas driver)
Date: Thu, 15 Sep 2005 13:22:01 +0100
Message-ID: <20050915122201.GA26829@infradead.org>
References: <91888D455306F94EBD4D168954A9457C0407A02F@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:15795 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751179AbVIOMWE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 08:22:04 -0400
Content-Disposition: inline
In-Reply-To: <91888D455306F94EBD4D168954A9457C0407A02F@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Wed, Sep 14, 2005 at 06:09:10PM -0600, Moore, Eric Dean wrote:
> I've reviewed patches today: 
> [PATCH 1/2] fusion core changes for SAS support
> [PATCH 2/2] fusion SAS support (mptsas driver)
> (However the driver oops when loading - sent
> email earlier today on that).
> 
> 
> These previous patches were posted last Friday
> seem fine, however I recommend we add the following 
> changes, and I've provided a patch attached to this email.

Looks good to me, except for the spurious scsi_print_command prototype
in mptscsih.h.  However this will conflict really badly with James
generic DV work..

