From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/5] arm: implement flush_kernel_dcache_page()
Date: Sun, 04 Jun 2006 00:04:25 -0700 (PDT)
Message-ID: <20060604.000425.21593578.davem@davemloft.net>
References: <1149392479281-git-send-email-htejun@gmail.com>
	<20060603.234517.104035250.davem@davemloft.net>
	<44828384.1080906@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl027-180-168.sfo1.dsl.speakeasy.net ([216.27.180.168]:10122
	"EHLO sunset.davemloft.net") by vger.kernel.org with ESMTP
	id S932144AbWFDHE1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jun 2006 03:04:27 -0400
In-Reply-To: <44828384.1080906@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: htejun@gmail.com
Cc: axboe@suse.de, James.Bottomley@SteelEye.com, davem@redhat.com, bzolnier@gmail.com, james.steward@dynamicratings.com, jgarzik@pobox.com, mattjreimer@gmail.com, g.liakhovetski@gmx.de, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>
Date: Sun, 04 Jun 2006 15:53:56 +0900

> Yeap, HEAD and index got out of sync while fetching & checking out. 
> I've sent a regenerated patch as a reply to the original message. 
> Haven't you received it?

Yeah I saw it right after I wrote that email :)
