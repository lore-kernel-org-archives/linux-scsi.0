From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: insmod options for aic7xxx
Date: Mon, 20 Oct 2003 20:30:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066696203.2624.0.camel@localhost.localdomain>
References: <S262839AbTJTVwK/20031020215210Z+18204@vger.kernel.org>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from leviathan.ele.uri.edu ([131.128.51.64]:55432 "EHLO
	leviathan.ele.uri.edu") by vger.kernel.org with ESMTP
	id S263413AbTJUAaK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2003 20:30:10 -0400
In-Reply-To: <S262839AbTJTVwK/20031020215210Z+18204@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "Deas, Jim" <James.Deas@warnerbros.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

for module load option, use modinfo

ming

On Mon, 2003-10-20 at 17:52, Deas, Jim wrote:
> Where can I find the module load options and IOCTLs for the aic7xxx SCSI
> module? I have checked the source tree docs but have not found anything.
> 
> I am looking for a way to mount and unmount SCSI drives that is a bit
> slicker than just loading and unloading the module.
> 
> Thanks for any help
> J. Deas
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

