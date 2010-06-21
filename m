From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/3] SCSI: Support Type C RAID controller
Date: Mon, 21 Jun 2010 09:16:29 -0500
Message-ID: <1277129789.10998.17.camel@mulgrave.site>
References: <76AB9A4FE9D94F96B7F79FC2896CC46E@areca4e4f859d4>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40424 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932544Ab0FUOQd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2010 10:16:33 -0400
In-Reply-To: <76AB9A4FE9D94F96B7F79FC2896CC46E@areca4e4f859d4>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nick.cheng@areca.com.tw
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 11:02 +0800, Nick Cheng wrote:
> 1. To support Type C RAID controller, ACB_ADAPTER_TYPE_C, i.e. PCI device
> ID: 0x1880.
> Signed-off-by: Nick Cheng< nick.cheng@areca.com.tw >

It's still giving the same rejections ... including the one I drew your
attention to in the header.  Either there's a patch missing somewhere,
or we're not working from the same base.  What I have is 2.6.35-rc3 plus
your patch 1/3 here

Message-id: <6D8C005181EA4A93BF2C281E4E1F72FC@areca4e4f859d4>

Let's try to come at this a different way since you don't seem to be
able to use git.  The current files I'm patching against are available
here (this includes your patch 1/3):

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=tree;f=drivers/scsi/arcmsr

You can download them directly from the web using the "raw" link.  Can
you make sure the patches you send apply cleanly to these files?

James


