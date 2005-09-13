From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/8] aacraid: error return checking
Date: Tue, 13 Sep 2005 11:06:46 +0100
Message-ID: <20050913100646.GD30375@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01919BC0@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:22455 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750716AbVIMKGt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 06:06:49 -0400
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01919BC0@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Sep 12, 2005 at 07:19:56AM -0400, Salyzyn, Mark wrote:
> We get complains about a driver module loaded with no associated
> hardware. There are system configurations that probe for installed
> hardware by loading modules, they expect only the functional driver
> modules to load. What purpose is there in a driver module that is loaded
> with no hardware?

Allow for hot-plug devices to be hanled without further user-space invention.
Your above probing method will have the same effect on every modern driver.

