From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] SPI transport class and generic Domain Validation for
	fusion
Date: Tue, 09 Aug 2005 14:09:56 -0500
Message-ID: <1123614596.5170.38.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C037B0EA1@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:13965 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932104AbVHITJ7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 15:09:59 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C037B0EA1@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-08-09 at 13:03 -0600, Moore, Eric Dean wrote:
> James: Your patches are not applying cleanly, so tell which kernel do I use
> as base to apply your patches?  
> 
> I don't use git to get the source, I'm pulling patches from www.kernel.org.

If you start with 2.6.13-rc6, you should be able to apply scsi-misc on
top of that, the patch is at:

http://www.kernel.org/pub/linux/kernel/people/jejb/scsi-misc-2.6.diff

Then the fusion DV patches should apply on top of that.

James


