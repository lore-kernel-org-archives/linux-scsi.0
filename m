From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: aic94xx status
Date: Thu, 20 Jul 2006 11:39:06 -0700 (PDT)
Message-ID: <20060720183906.87217.qmail@web31813.mail.mud.yahoo.com>
References: <44BF95A0.1090703@us.ibm.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31813.mail.mud.yahoo.com ([68.142.207.76]:13487 "HELO
	web31813.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1750861AbWGTSjH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jul 2006 14:39:07 -0400
In-Reply-To: <44BF95A0.1090703@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>, Robert Tarte <robt@PacificCodeWorks.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

--- Brian King <brking@us.ibm.com> wrote:
> Robert Tarte wrote:
> >> 1) SATA support.  We at least need this stubbed out so seeing a SATA
> >> device won't cause nasty things to happen (IBM is working on this).
> >> Ideally, we need to integrate this driver with Brian King's SATA/SAS
> >> code, but no-one who has this board has a sata device and vice versa.
> > 
> > [Tarte, Robert] I'm not sure what Brian King's SATA/SA code is, but I do
> > have boards that use the razor chip and I have SATA devices.
> 
> The patch referred to here is a patch to libata that adds a set of APIs
> that allows a SAS HBA to hook into libata to control SATA devices. It
> was written so that I could get ipr to hook into libata, and the hope
> is that it could be used by other SAS drivers as well. Unfortunately,
> no other SAS drivers that support SATA passthrough have really tried
> using it yet.

Maybe this is because they have SATL a la proper.

   Luben
 
> http://marc.theaimsgroup.com/?l=linux-ide&m=115279779219927&w=2
> 
> Brian
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

