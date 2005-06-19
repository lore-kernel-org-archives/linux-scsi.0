From: "David S. Miller" <davem@davemloft.net>
Subject: Re: recent scsi changes break fc4 build
Date: Sun, 19 Jun 2005 13:02:41 -0700 (PDT)
Message-ID: <20050619.130241.71551863.davem@davemloft.net>
References: <20050618.231646.91312440.davem@davemloft.net>
	<42B592A3.8050600@pobox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl027-180-168.sfo1.dsl.speakeasy.net ([216.27.180.168]:54938
	"EHLO sunset.davemloft.net") by vger.kernel.org with ESMTP
	id S261307AbVFSUDX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 16:03:23 -0400
In-Reply-To: <42B592A3.8050600@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org

From: Jeff Garzik <jgarzik@pobox.com>
Date: Sun, 19 Jun 2005 11:43:31 -0400

> Does the attached patch work for you?

Yep, that fixes the build.  Please push upstream :)

Thanks a lot Jeff.
