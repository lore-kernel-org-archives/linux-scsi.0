From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] [SCSI] ipr: Fix stack overflow in
 ipr_format_resource_path
Date: Thu, 3 Jun 2010 14:20:19 +1000
Message-ID: <20100603042019.GI28295@kryten>
References: <20100602111658.GH28295@kryten>
 <4C072C18.4030005@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:33011 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab0FCEWx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jun 2010 00:22:53 -0400
Content-Disposition: inline
In-Reply-To: <4C072C18.4030005@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Cc: brking@us.ibm.com, betabandido@gmail.com, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org


Hi Wayne,

> We also saw a variation of this problem last week and I have an alternative
> patch that I'd prefer over this one.  I'll post the patch in a separate
> email.

Thanks. Can you get it into -stable too? As you can see users are hitting it.

Anton
