From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v4 00/10] SCSI: esas2r: ATTO Technology ExpressSAS 6G
 SAS/SATA RAID Adapter Driver
Date: Mon, 26 Aug 2013 09:59:28 +0000
Message-ID: <1377511166.20958.2.camel@dabdike>
References: <1377268554-25898-1-git-send-email-bgrove@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:42698 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab3HZKBB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2013 06:01:01 -0400
In-Reply-To: <1377268554-25898-1-git-send-email-bgrove@attotech.com>
Content-Language: en-US
Content-ID: <FD9110AB8414F6478CCD89773955D0D2@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bradley Grove <bgrove@attotech.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jseba@attotech.com" <jseba@attotech.com>

On Fri, 2013-08-23 at 10:35 -0400, Bradley Grove wrote:
> This is a new driver for ATTO Technology's ExpressSAS series of
> hardware RAID 
> adapters.  It supports the following adapters:
> 
>     - ExpressSAS R60F
>     - ExpressSAS R680
>     - ExpressSAS R608
>     - ExpressSAS R644

OK, I put this in misc.  I suspect I was the only person who actually
reviewed it, so I want to see what the static checkers report on it, but
if they don't spit back anything too bad, I think it can go into the
next merge window.

James

