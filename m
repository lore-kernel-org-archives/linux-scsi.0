From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] IBM VSCSI Client: handle large scatter/gather lists
Date: Tue, 06 Sep 2005 09:13:25 -0500
Message-ID: <1126016005.5012.1.camel@mulgrave>
References: <42C2D85E.5010306@us.ibm.com>
	 <20050906074943.GS6945@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:41451 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750817AbVIFONs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Sep 2005 10:13:48 -0400
In-Reply-To: <20050906074943.GS6945@krispykreme>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: Linda Xie <lxiep@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Dave C Boutcher <sleddog@us.ibm.com>, Santiago Leon <santil@us.ibm.com>

On Tue, 2005-09-06 at 17:49 +1000, Anton Blanchard wrote:
> Any chance we could get this into 2.6.14? I just tested it on current
> git and as expected the number of sg elements increased. Testing a dd
> from a virtual disk with clustering disabled (to avoid physical merging
> effects) shows:

Yes ... but according to my records it wasn't acked by the
maintainer ... does he agree?

James


