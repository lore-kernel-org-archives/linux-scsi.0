From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ANNOUNCE dc395x update [2.03]
Date: Tue, 13 May 2003 11:48:56 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030513114856.A16295@infradead.org>
References: <20030423072737.GA5529@twibble.org> <20030513090535.GA5528@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from carisma.slowglass.com ([195.224.96.167]:51718 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263309AbTEMKgL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2003 06:36:11 -0400
Content-Disposition: inline
In-Reply-To: <20030513090535.GA5528@twibble.org>; from lenehan@twibble.org on Tue, May 13, 2003 at 07:05:35PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lenehan <lenehan@twibble.org>
Cc: dc395x@twibble.org, linux-scsi@vger.kernel.org

On Tue, May 13, 2003 at 07:05:35PM +1000, Jamie Lenehan wrote:
>  - Cleanup function scope. Make everything except the module init
>    functions static.

everything should be static, including module init functions.

