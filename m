From: adam radford <aradford@gmail.com>
Subject: Re: [RFQ] New driver architecture questions
Date: Thu, 14 May 2009 17:58:03 -0700
Message-ID: <b1bc6a000905141758y20aa7852h8b1012e3da6f8c0f@mail.gmail.com>
References: <6C678488C5CEE74F813A4D1948FD2DC7A95E6D37@cosmail02.lsi.com>
	 <4A0B858F.3080405@garzik.org>
	 <6C678488C5CEE74F813A4D1948FD2DC7A95E6D38@cosmail02.lsi.com>
	 <4A0B9B0D.6080006@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:34465 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbZEOA6E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2009 20:58:04 -0400
In-Reply-To: <4A0B9B0D.6080006@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: "Mukker, Atul" <Atul.Mukker@lsi.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, May 13, 2009 at 9:16 PM, Jeff Garzik <jeff@garzik.org> wrote:
> Taking drivers/net/e1000e as an
> example,
>
>        hw.h            hardware-specific defines, ~cross-OS
>        82571.c         code specific to 8257x chip family, ~cross-OS

82571.c contains Linux specific code such as:  including Linux
specific header files, calls to msleep().

>        ich8lan.c       code specific to ICH8+ chip family, ~cross-OS

ich8lan.c contains Linux specific code such as:  might_sleep(),
mutex_trylock(), mutex_unlock(), udelay(), msleep(), writel(), readl().

Perhaps this is a bad example?  It seems like the "common layer"
sections that are "cross-OS" shouldn't contain any Linux specific code at all.

-Adam
