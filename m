From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: using a PERC6/i (MegaRaid SAS 1078) in JBOD mode?
Date: Mon, 25 Oct 2010 08:11:14 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3010111F783@cosmail02.lsi.com>
References: <20101023095816.GA19791@apartia.fr>
 <4B6A08C587958942AA3002690DD4F8C3010111F73E@cosmail02.lsi.com>
 <20101025131937.GA6605@apartia.fr>
 <20101025154705.73d49860@harpe.intellique.com>
 <20101025135647.GA14302@apartia.fr>
 <4B6A08C587958942AA3002690DD4F8C3010111F771@cosmail02.lsi.com>
 <20101025140905.GA20569@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:54399 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755733Ab0JYOLi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2010 10:11:38 -0400
In-Reply-To: <20101025140905.GA20569@apartia.fr>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Does the ctrl^H work for you?


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Louis-David Mitterrand
Sent: Monday, October 25, 2010 10:09 AM
To: linux-scsi@vger.kernel.org
Subject: Re: using a PERC6/i (MegaRaid SAS 1078) in JBOD mode?

On Mon, Oct 25, 2010 at 08:02:22AM -0600, Yang, Bo wrote:
> You also can use ctrl^H during the controller post to configure the JBOD.  

Unfortuntely I found no way to configure disks in JBOD mode through the
adapter bios. A google search seems to indicate other users have the
same problem.

Apparently a firmware change (to "initiator and target" mode) is
required to turn that adapter's into a simple non-raid SATA controller
but I couldn't find it anywhere.

Any idea?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
