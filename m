From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: increasing scsi_max_sg / max_segments for scsi writes/reads
Date: Mon, 18 Apr 2005 09:12:41 -0500
Message-ID: <1113833561.4998.10.camel@mulgrave>
References: <20050418061723.49716.qmail@web54105.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:29159 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262082AbVDROMw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Apr 2005 10:12:52 -0400
In-Reply-To: <20050418061723.49716.qmail@web54105.mail.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sai narasimhamurthy <sai_narasi@yahoo.com>
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Sun, 2005-04-17 at 23:17 -0700, sai narasimhamurthy wrote:
> I tried working on scsi_malloc to increase burst size
> , but to no avail ..all I got was hanged system every
> time I started data transfers! 
> Has anyone worked on scsi_malloc , I am still trying
> to figure out what changes were made in 2.6 to
> overcome this problem of limited bursts. 

The change in 2.6 was to dump scsi_malloc and use mempools instead for
the sg list.

> Any pointers are very greatly welcome...I have never
> worked on this part of the code before .

Upgrade to 2.6 ... seriously ... what you're trying to do is what 2.6
was designed for.

James


