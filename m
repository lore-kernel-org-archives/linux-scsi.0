From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch-kj] remove old ifdef'd code from
Date: Mon, 21 Jun 2004 19:31:40 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621183140.GA22588@infradead.org>
References: <20040621182918.GX1545@sputnik.stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:57575 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S266390AbUFUSbn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 14:31:43 -0400
Content-Disposition: inline
In-Reply-To: <20040621182918.GX1545@sputnik.stro.at>
List-Id: linux-scsi@vger.kernel.org
To: maximilian attems <janitor@sternwelten.at>
Cc: garloff@suse.de, linux-scsi@vger.kernel.org

On Mon, Jun 21, 2004 at 08:29:18PM +0200, maximilian attems wrote:
> 
>  From: Domen Puncer <domen@coderock.org>
>  Patches to remove some old ifdefs.
>  Signed-off-by: Maximilian Attems <janitor@sternwelten.at>

While the changes are okay, this driver is beeing changed rapidly and I
have a patch pending that's a supertset of yours.  So please don't apply
James.

