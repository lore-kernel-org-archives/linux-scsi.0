From: Michael Reed <mdr@sgi.com>
Subject: Re: fibre channel sync cache question
Date: Wed, 26 Jul 2006 13:40:08 -0500
Message-ID: <44C7B708.4040804@sgi.com>
References: <664A4EBB07F29743873A87CF62C26D70248ED4@NAMAIL4.ad.lsil.com> <1153867194.8932.66.camel@laptopd505.fenrus.org> <44C6E6C7.8090606@torque.net> <44C7B269.4070505@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:50883 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1161030AbWGZSkT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jul 2006 14:40:19 -0400
In-Reply-To: <44C7B269.4070505@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: dougg@torque.net, Arjan van de Ven <arjan@infradead.org>, "Moore, Eric" <Eric.Moore@lsil.com>, James Smart <James.Smart@Emulex.Com>, linux-scsi@vger.kernel.org



Michael Reed wrote:

> 
> In a closer look at the target removal via sysfs device/delete,
> I observe that portions of the sysfs fc_remote_ports/rport-*
> remain in place.
> 

Doh.  What a stupid observation I made.  It's working as intended.
It keeps the bindings around.

Mike

> Do we need to tie the device/delete to the transport?
> 
> Can of worms?  Close eyes, run screaming?
> 
> Mike
> 
> 
