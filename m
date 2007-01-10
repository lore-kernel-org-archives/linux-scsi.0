From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: description on KEYs in .config file
Date: Tue, 9 Jan 2007 16:51:59 -0800
Message-ID: <20070109165159.f469feb0.rdunlap@xenotime.net>
References: <a02278b00701091640k312b4818w51f336ca3ec36933@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:33636 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932578AbXAJAvs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Jan 2007 19:51:48 -0500
Received: from midway.site ([71.245.99.70]) by xenotime.net for <linux-scsi@vger.kernel.org>; Tue, 9 Jan 2007 16:51:43 -0800
In-Reply-To: <a02278b00701091640k312b4818w51f336ca3ec36933@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Allexio Ju <allexio.ju@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 9 Jan 2007 16:40:05 -0800 Allexio Ju wrote:

> Hi,
> 
> Where can I get detail description on each KEYs in .config file?
> I'm trying to understand what are the meaning of those before turn thme on/off.

In the many Kconfig and Kconfig.* files in the kernel tree.
Or by using one of the config tools "make menuconfig/xconfig/gconfig"
and reading the Help text.

---
~Randy
