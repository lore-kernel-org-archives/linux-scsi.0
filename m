From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Adaptec HostRAID for 7902 in 2.6 kernel series
Date: Tue, 21 Dec 2004 08:35:44 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B909854@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:51639 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261758AbULUNfs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2004 08:35:48 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>, Mark Rustad <mrustad@mac.com>
Cc: linux-scsi@vger.kernel.org

Adaptec had supplied an emd raid driver to the raid list. That code
could be mined for the meta-data handling for dm.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Arjan van de Ven
Sent: Tuesday, December 21, 2004 6:38 AM
To: Mark Rustad
Cc: linux-scsi@vger.kernel.org
Subject: Re: Adaptec HostRAID for 7902 in 2.6 kernel series

On Mon, 2004-12-20 at 17:51 -0600, Mark Rustad wrote:
> Folks,
> 
> Is there any support for the Adaptec 7902 HostRAID operation using the

> 2.6 kernel series? I have seen the binary modules on the Adaptec site 
> for the 2.4 kernels and I have tried various 2.6 kernels. Some of the 
> 2.6 kernels do not see the device when it is set up for HostRaid, 
> others see the underlying raw devices, which doesn't seem right.

it's actually right; hostraid is software raid, in linux the "dmraid"
tool is used to drive all such raids. I'm not sure dmraid currently
supports HostRaid, however if you contact ataraid-list@redhat.com the
people there might just be able to write a format-driver for this raid
format easily.


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
