From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [RFC: 2.6 patch] remove ISA legacy functions
Date: Sat, 12 Nov 2005 13:48:20 +0000
Message-ID: <20051112134820.GG7992@ftp.linux.org.uk>
References: <20051111021258.GK5376@stusta.de> <20051110182443.514622ed.akpm@osdl.org> <20051111201849.GP5376@stusta.de> <20051111202005.GQ5376@stusta.de> <20051111203601.GR5376@stusta.de> <20051112045216.GY5376@stusta.de> <437578CD.1080501@pobox.com> <20051112051102.GF1658@parisc-linux.org> <43757D5C.8030308@pobox.com> <20051112052918.GG1658@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:30136 "EHLO
	ZenIV.linux.org.uk") by vger.kernel.org with ESMTP id S932370AbVKLNvm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Nov 2005 08:51:42 -0500
Content-Disposition: inline
In-Reply-To: <20051112052918.GG1658@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jeff Garzik <jgarzik@pobox.com>, Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, jonathan@buzzard.org.uk, tlinux-users@tce.toshiba-dme.co.jp, Jaroslav Kysela <perex@suse.cz>

On Fri, Nov 11, 2005 at 10:29:18PM -0700, Matthew Wilcox wrote:
> I think they work fine everywhere.  Adrian wants to remove the API they
> use.
> 
> I think this is a bad idea.  The drivers should be converted.

They are - I'll send patches later today...
