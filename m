From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Symbios-NCR 6285-3621 + Adaptec 2944W multilun problem
Date: Fri, 12 May 2006 12:22:52 -0500
Message-ID: <1147454573.3769.32.camel@mulgrave.il.steeleye.com>
References: <44648D9C.2090602@cooperativaobrera.com.ar>
	 <1147442986.3769.2.camel@mulgrave.il.steeleye.com>
	 <44649CE5.7070604@cooperativaobrera.com.ar>
	 <1147446596.3769.25.camel@mulgrave.il.steeleye.com>
	 <4464C384.2050605@cooperativaobrera.com.ar>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:38840 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751106AbWELRW6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 13:22:58 -0400
In-Reply-To: <4464C384.2050605@cooperativaobrera.com.ar>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Gomiz <gomita@cooperativaobrera.com.ar>
Cc: linux-scsi@vger.kernel.org

On Fri, 2006-05-12 at 14:19 -0300, Gabriel Gomiz wrote:
> You were right. The server was attached to controller "B" of the array. 
> I attached it to controller "A" and it is working ok with 2.6.16.13 
> vanilla kernel!!!
> 
> But with 2.6.9-34EL Red Hat Enterprise Stock kernel I'm still having 
> errors and dmesg output is a lot more verbose. I'm attaching both dmesg 
> outputs just in case it helps.
> Do I need to report this to Red Hat?
> Is it a bug? or a kernel configuration error?

You didn't attach the dmesg ... but I'm afraid RHEL3 is probably too old
for me to be of much help anyway, so Red Hat is your best bet.

> BTW: Do anybody in this list knows how to manage this model of array 
> from Linux? Any software available? Boot disk? Symplicity Software? Any 
> hint you can provide will be greatly appreciated.
> Array model is Symbios/NCR 6285-3621.

No.  The Java based symplicity will run on Linux, but it can only manage
network connected arrays.  The 6285 is vintage 1996 or so and is too old
for that.  You can really only manage it on Operating Systems which have
the symplicity support built in.

James


