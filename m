From: Gabriel Gomiz <gomita@cooperativaobrera.com.ar>
Subject: Re: Symbios-NCR 6285-3621 + Adaptec 2944W multilun problem
Date: Fri, 12 May 2006 14:19:00 -0300
Message-ID: <4464C384.2050605@cooperativaobrera.com.ar>
References: <44648D9C.2090602@cooperativaobrera.com.ar>	 <1147442986.3769.2.camel@mulgrave.il.steeleye.com>	 <44649CE5.7070604@cooperativaobrera.com.ar> <1147446596.3769.25.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 200-26-107-84.advance.com.ar ([200.26.107.84]:22730 "EHLO
	thorin.cooperativaobrera.com.ar") by vger.kernel.org with ESMTP
	id S1750837AbWELRTQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 13:19:16 -0400
In-Reply-To: <1147446596.3769.25.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> Well, what I was hoping for was mode sense messages but, unfortunately,
> there aren't any.  My suspicion is that the 6285 is dual controller
> running in RDAC mode and you're attached to the inactive controller (in
> that configuration it allowed INQUIRY and MODE SENSE through but errors
> out on all other I/O operations).  I think you can verify by physically
> removing one of the controllers and rebooting the array (or just attach
> the SCSI cable to the other controller)

James:

You were right. The server was attached to controller "B" of the array. 
I attached it to controller "A" and it is working ok with 2.6.16.13 
vanilla kernel!!!

But with 2.6.9-34EL Red Hat Enterprise Stock kernel I'm still having 
errors and dmesg output is a lot more verbose. I'm attaching both dmesg 
outputs just in case it helps.
Do I need to report this to Red Hat?
Is it a bug? or a kernel configuration error?

BTW: Do anybody in this list knows how to manage this model of array 
from Linux? Any software available? Boot disk? Symplicity Software? Any 
hint you can provide will be greatly appreciated.
Array model is Symbios/NCR 6285-3621.

Again, many thanks for your wonderful support!

-- 
       .^.    Lic. Gabriel Gomiz - Red Hat Certified Engineer (RHCE)
       /V\    Administrador Red/Sistemas - Desarrollo Sistema POSEIDON
      // \\   Gerencia de Sistemas - Cooperativa Obrera Ltda.
     /(   )\  Tel (0291) 456-0084
      ^^-^^   s/Window[$s]/LINUX!!/g or die;

