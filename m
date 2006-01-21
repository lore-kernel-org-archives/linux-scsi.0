From: Chase Venters <chase.venters@clientec.com>
Subject: Re: OOM Killer killing whole system
Date: Fri, 20 Jan 2006 22:35:26 -0600
Message-ID: <200601202235.48352.chase.venters@clientec.com>
References: <1137337516.11767.50.camel@localhost> <200601202153.27386.chase.venters@clientec.com> <1137817289.11771.85.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay03.pair.com ([209.68.5.17]:65287 "HELO relay03.pair.com")
	by vger.kernel.org with SMTP id S1161233AbWAUEf5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jan 2006 23:35:57 -0500
In-Reply-To: <1137817289.11771.85.camel@localhost>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anton Titov <a.titov@host.bg>
Cc: JamesBottomley <James.Bottomley@steeleye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Friday 20 January 2006 22:21, Anton Titov wrote:
> On Fri, 2006-01-20 at 21:53 -0600, Chase Venters wrote:
> > Random guess... Asus P5GDC-V with Firewire and USB turned off?
>
> Exactly (Asus P5GDC-V Deluxe actually, with few more things off). So
> maybe it's ICH6?

Just a shot in the dark, but in the last few kernel revisions have you 
experienced any SATA problems with DMA timeouts, in some versions leading to 
a hang?

Cheers,
Chase
