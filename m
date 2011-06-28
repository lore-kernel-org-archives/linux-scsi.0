From: Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH][Resend] SCSI, target, loopback: Fix memory leak in
 tcm_loop_make_scsi_hba()
Date: Tue, 28 Jun 2011 09:22:35 +0300
Message-ID: <20110628062235.GB14591@shale.localdomain>
References: <alpine.LNX.2.00.1106272351520.30245@swampdragon.chaosbits.net>
 <20110627222526.GA14591@shale.localdomain>
 <alpine.LNX.2.00.1106280029150.30245@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52859 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab1F1GXg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2011 02:23:36 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1106280029150.30245@swampdragon.chaosbits.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 12:30:17AM +0200, Jesper Juhl wrote:
> 
> You mean like this - right?

Yeah.

Acked-by: Dan Carpenter <error27@gmail.com>

regards,
dan carpenter

