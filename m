From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Low-level reformat with different sector size: ?
Date: Fri, 29 Jun 2007 11:50:44 -0400
Message-ID: <1183132245.3518.28.camel@localhost.localdomain>
References: <f638pe$it6$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:37767 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763220AbXF2Pus (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jun 2007 11:50:48 -0400
In-Reply-To: <f638pe$it6$1@sea.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-scsi@vger.kernel.org

On Fri, 2007-06-29 at 15:34 +0000, Matthias Urlichs wrote:
> Yesterday I managed to buy a couple of SCA disks with a sector size of ...
> *drumroll* ... 524.
> 
> What's the easiest way to re-format these to use 512 bytes?
> Preferably without screwing up anything else on these things?

We use this program go reformat 520 sector size disks back to 512:

http://parisc-linux.org/~jejb/blk512-linux.c

It should work for your device as well.  Beware it requires a complete
low level format to achieve this, which can take a very long time.

James


