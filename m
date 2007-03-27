From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [patch 19/28] drivers/scsi/aacraid/: cleanups
Date: Tue, 27 Mar 2007 09:19:37 -0500
Message-ID: <1175005178.3737.9.camel@mulgrave.il.steeleye.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF017A97B5@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:57859 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753868AbXC0OXF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Mar 2007 10:23:05 -0400
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF017A97B5@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: bunk@stusta.de, akpm@linux-foundation.org, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2007-03-27 at 09:00 -0400, Salyzyn, Mark wrote:
> I believe this is the third time I've seen this patch and had applied it
> to the Adaptec sources. James, please apply to your tree, I
> wholeheartedly agree with this patch! The same goes to the 'dpt_i2o.c'
> remove dead code patch ...

Sure, I can add it.

Just to make sure everyone understands, there are two methods for
getting things like this into maintained drivers

     1. Just ack it and I'll add it with an "Acked-by:" tag.  This is
        fine except when it produces merge conflicts with another update
        (in which case I become unhappy).
     2. Import it into your own patch tree (and add your own
        "Signed-off-by:") and then transmit it as part of your regular
        patches (I like this because it means I don't have to manage any
        conflicts).

James

P.S. are you taking on maintenance of dpt_i2o?



