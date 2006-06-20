From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: Status of SAS ability to attach SATA devices
Date: Mon, 19 Jun 2006 20:31:06 -0700 (PDT)
Message-ID: <20060620033106.22886.qmail@web31807.mail.mud.yahoo.com>
References: <6ac07bf90606191047o131ec37eq6e1bcaf6205ea8ea@mail.gmail.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31807.mail.mud.yahoo.com ([68.142.207.70]:17313 "HELO
	web31807.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S965448AbWFTDbH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jun 2006 23:31:07 -0400
In-Reply-To: <6ac07bf90606191047o131ec37eq6e1bcaf6205ea8ea@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ilia Sotnikov <hostcc@gmail.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com, James.Bottomley@steeleye.com

--- Ilia Sotnikov <hostcc@gmail.com> wrote:
> Hardware: IBM 206m, AIC 9405 SAS/SATA controller, 2 SATA drives.
> 
> Having read several threads about SAS ability to attach SATA devices
> (what's needed in my case), I found that this is work-in-progress.
> 
> Also during the investigation I've found that there are exist several
> GIT trees with different SAS / AIC94xx versions: maintained by James
> Bottomley, Jeff Garzik and Luben Tuikov.

One of my GIT trees, has a spec complient SATL (with NCQ, etc) which
integrates with the aforementioned driver (the version I maintain,
not Bottomley's/Garzik's version).

    Luben

> I've tried all three of above mentioned versions - PHYs are discovered
> correctly (as far as I can tell) but no disk devices are registered.
> According to comments in sources that's predictable.
> 
> Questions are:
> - what tree is recommended to work on;
> - how could I help (if could) to improve the situation.
> 
> Thanks in advance,
> -- 
>  Ilia Sotnikov
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

