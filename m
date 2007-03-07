From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 29/29] bug in gdth.c crashing machine
Date: Wed, 07 Mar 2007 11:28:25 -0600
Message-ID: <1173288505.3771.33.camel@mulgrave.il.steeleye.com>
References: <200703061046.l26AksTi020093@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:35329 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422885AbXCGR2b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Mar 2007 12:28:31 -0500
In-Reply-To: <200703061046.l26AksTi020093@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, joerg@dorchain.net, Achim_Leubner@adaptec.com, stable@kernel.org

On Tue, 2007-03-06 at 02:46 -0800, akpm@linux-foundation.org wrote:
> From: Joerg Dorchain <joerg@dorchain.net>
> 
> Undocumented...

This is a bit of a problem, isn't it?

I have no report of any problem this fixes, and no input from the gdth
maintainer about this.  The first I actually knew of this patch request
is that it appeared in an akpm patch stream yesterday.

I really think we need more details before this gets applied to
anything, let alone the stable tree.

James


