From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sym53c8xx module parameter passing not working (2.5.6)
Date: Fri, 1 Oct 2004 16:29:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041001162939.A4215@infradead.org>
References: <7AAD212492598A4A92463C3F5D34C54F194EDC@ccd3.CC.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:3846 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261610AbUJAP3n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Oct 2004 11:29:43 -0400
Content-Disposition: inline
In-Reply-To: <7AAD212492598A4A92463C3F5D34C54F194EDC@ccd3.CC.de>; from Heinzmann@cc-dresden.de on Fri, Oct 01, 2004 at 05:26:21PM +0200
List-Id: linux-scsi@vger.kernel.org
To: "Heinzmann, Robert" <Heinzmann@cc-dresden.de>
Cc: linux-scsi@vger.kernel.org

On Fri, Oct 01, 2004 at 05:26:21PM +0200, Heinzmann, Robert wrote:
> Hello, 
> 
> attached there is a patch that fixes the module parameter passing with
> sym53c8xx_2. This is for SLES9 SuSE kernel, but it is so small that it
> should apply for other kernels too.

Given that no one except you noticed the lack of options so far what
about moving it to normal parameters instead, aka one option per setting
like all non-scsi and resent scsi drivers do?

