From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6 patch] SCSI t128.c: remove an unused function
Date: Mon, 15 Nov 2004 14:40:39 +0000
Message-ID: <1100529621.27202.9.camel@localhost.localdomain>
References: <20041115023859.GE2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261629AbUKOPp6@vger.kernel.org>
In-Reply-To: <20041115023859.GE2249@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Llu, 2004-11-15 at 02:38, Adrian Bunk wrote:
> The patch below removes the unused function t128_setup.
> 
> Please review whether it's correct.

Its wrong. The fix is to make the setup function get called, IFF you can
find anyone with a t128 any more
