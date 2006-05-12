From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Symbios-NCR 6285-3621 + Adaptec 2944W multilun problem
Date: Fri, 12 May 2006 09:09:46 -0500
Message-ID: <1147442986.3769.2.camel@mulgrave.il.steeleye.com>
References: <44648D9C.2090602@cooperativaobrera.com.ar>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:28069 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932088AbWELOKA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 10:10:00 -0400
In-Reply-To: <44648D9C.2090602@cooperativaobrera.com.ar>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Gomiz <gomita@cooperativaobrera.com.ar>
Cc: linux-scsi@vger.kernel.org

On Fri, 2006-05-12 at 10:29 -0300, Gabriel Gomiz wrote:
> When configuring 2.6.16.13 kernel scsi subsystem with multilun
> support, 
> I'm trying to access a Symbios 6285-3621 Array via an Adaptec 2944W
> HBA 
> with aic7xxx module. All scsi "virtual devices" are recognized 
> sdc-sdd-sde-sdf-sdg-sdh-sdi but then when the kernel tries to detect
> the 
> partition tables it gets a lot of "Buffer I/O errors".

Could we get the dmesg output, both of the devices being detected, and
when the I/O errors occur, please?

James


