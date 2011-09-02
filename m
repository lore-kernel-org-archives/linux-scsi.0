From: Mike Galbraith <efault@gmx.de>
Subject: Re: [BUG] scsi: hpsa: how to destroy your files
Date: Fri, 02 Sep 2011 07:18:36 +0200
Message-ID: <1314940716.6336.8.camel@marge.simson.net>
References: <20110721181605.31672.36250.stgit@beardog.cce.hp.com>
	 <1314890642.2823.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:51669 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750904Ab1IBFSm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Sep 2011 01:18:42 -0400
In-Reply-To: <1314890642.2823.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com

On Thu, 2011-09-01 at 17:24 +0200, Eric Dumazet wrote:
> Stephen,
> 
> Current linux-3.1-rc4+ is a total disaster on my BL460c G6
> 
> 
> Few seconds after boot, I get "cmd_alloc returned NULL" messages
> or "hpsa 0000:0c:00.0: resetting device 0:0:0:0"

Bingo.

> Usually lot of files are corrupted, fsck needed, and full distro
> reinstall as well.

(I put tip-rt11 on a DL980 three times.. munched fs each time)

