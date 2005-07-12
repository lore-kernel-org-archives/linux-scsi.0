From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 22/82] remove linux/version.h from drivers/message/fus
 ion
Date: Tue, 12 Jul 2005 15:14:38 -0700 (PDT)
Message-ID: <20050712.151438.130617309.davem@davemloft.net>
References: <91888D455306F94EBD4D168954A9457C03157047@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl027-180-168.sfo1.dsl.speakeasy.net ([216.27.180.168]:16822
	"EHLO sunset.davemloft.net") by vger.kernel.org with ESMTP
	id S262458AbVGLWOs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2005 18:14:48 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C03157047@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsil.com
Cc: tduffy@sun.com, olh@suse.de, akpm@osdl.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Date: Tue, 12 Jul 2005 14:50:19 -0600

> But Id rather have same files in our maintained driver,
> and whats in the kernel tree.

Just think what a mess we'd have on our hands if we let
everyone do that.  Sorry, please don't put compat header
files into the current upstream tree, thanks.
