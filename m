From: =?ISO-8859-1?Q?Hajo_M=F6ller?= <dasjoe@gmail.com>
Subject: Re: Can not see/access devices on Marvell 88SE9485 + SiI 3726 PMP
Date: Wed, 03 Jul 2013 14:52:55 +0200
Message-ID: <51D41EA7.20308@gmail.com>
References: <51D18DA6.8000502@gmail.com> <1372689482.2385.15.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:42056 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab3GCMw6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jul 2013 08:52:58 -0400
Received: by mail-bk0-f48.google.com with SMTP id jf17so52789bkc.7
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jul 2013 05:52:57 -0700 (PDT)
In-Reply-To: <1372689482.2385.15.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, yuxiangl@marvell.com

On 01.07.2013 16:38, James Bottomley wrote:
> mv_sas is a libsas based driver.  libsas doesn't have any support for
> SATA PMPs.  When it was added they were left as a todo item but then in
> the field everyone deployed enterprise type SATA devices in SAS expander
> chassis, so PMP support just got forgotten.

That's a pity, so it's unlikely libsas will get support for PMPs in the
near future or at all?  Sadly I'm not able to add the support myself.

Do you know of any SAS controllers which do support SATA PMPs?
I'm stuck with the PMPs, so I'm trying a SATA controller with an
88SX7042 next, although having a good SAS controller would be better in
the long run.

Greetings,
Hajo
