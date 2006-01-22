From: Andrew Morton <akpm@osdl.org>
Subject: Re: memory leak in scsi_cmd_cache 2.6.15
Date: Sat, 21 Jan 2006 22:58:45 -0800
Message-ID: <20060121225845.71cb7cad.akpm@osdl.org>
References: <Pine.LNX.4.62.0601212105590.22868@pureeloreel.qftzy.pbz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:24037 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751066AbWAVG7F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jan 2006 01:59:05 -0500
In-Reply-To: <Pine.LNX.4.62.0601212105590.22868@pureeloreel.qftzy.pbz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ariel <askernel2615@dsgml.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Ariel <askernel2615@dsgml.com> wrote:
>
> I have a memory leak in scsi_cmd_cache.

You're no the only one.  Please send the full `dmesg -s 1000000' output so
we can see which devices and drivers are in use.

Thanks.
