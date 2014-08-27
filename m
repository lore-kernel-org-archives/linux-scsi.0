From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH 1/5] ipr: Add support for async scanning to speed up
 boot
Date: Wed, 27 Aug 2014 14:04:08 +1000
Message-ID: <20140827140408.4872f089@kryten>
References: <53D6B254.1090503@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:53452 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbaH0EEO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2014 00:04:14 -0400
In-Reply-To: <53D6B254.1090503@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>


Hi Brian,

> Switch device scanning logic in the ipr driver to use
> the async scan API. This speeds up boot times, particularly
> on large systems.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>

This reduces the boot time on my box by over 3 seconds. I'm sure it
reduces it much more after your subsequent kexec patch is applied.

Tested-by: Anton Blanchard <anton@samba.org>

Anton
