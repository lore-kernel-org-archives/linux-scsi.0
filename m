From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] NCR53c406a.c warning
Date: 12 Sep 2003 09:41:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1063374111.1767.2.camel@mulgrave>
References: <Pine.GSO.4.21.0309110836030.1879-100000@vervain.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:64004 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261611AbTILNl6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2003 09:41:58 -0400
In-Reply-To: <Pine.GSO.4.21.0309110836030.1879-100000@vervain.sonytel.be>
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Development <linux-kernel@vger.kernel.org>

On Thu, 2003-09-11 at 02:37, Geert Uytterhoeven wrote:
> NCR53c406a: Apparently wait_intr() is unused, so remove it.

It is currently unused.  However, the reason is that we removed the scsi
command method that allows polled operation in a driver (this routine is
actually polling the interrupt port on the chip).

I'd like to wait a while to see if anyone still needs this mode when 2.6
gets a wider test audience.  If you wish, you can surround the routine
with #if 0 and a comment saying we can junk it later if it really is
unnecessary.

Thanks,

James


