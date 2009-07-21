From: "Mukker, Atul" <Atul.Mukker@lsi.com>
Subject: RE: Recommended HBA management interfaces
Date: Tue, 21 Jul 2009 07:38:37 -0600
Message-ID: <6C678488C5CEE74F813A4D1948FD2DC7A99EFF8A@cosmail02.lsi.com>
References: <6C678488C5CEE74F813A4D1948FD2DC7A998698F@cosmail02.lsi.com>
 <4A609A55.9040404@linux.vnet.ibm.com>
 <6C678488C5CEE74F813A4D1948FD2DC7A99EFDC7@cosmail02.lsi.com>
 <4A64A20A.5080908@emulex.com>
 <6C678488C5CEE74F813A4D1948FD2DC7A99EFE16@cosmail02.lsi.com>
 <4A64C0BD.5040503@emulex.com>
 <6C678488C5CEE74F813A4D1948FD2DC7A99EFE88@cosmail02.lsi.com>
 <4A65B4A2.70402@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og110.obsmtp.com ([64.18.2.173]:56728 "EHLO
	exprod7og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZGUNil convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2009 09:38:41 -0400
In-Reply-To: <4A65B4A2.70402@emulex.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Brian King <brking@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Thanks again for your inputs. Without going into philosophical details on what and how, we just want to figure out what is (and not) technically possible across various platforms, which you have answered very well.

Best regards,
Atul Mukker


> -----Original Message-----
> From: James Smart [mailto:James.Smart@Emulex.Com]
> Sent: Tuesday, July 21, 2009 8:29 AM
> To: Mukker, Atul
> Cc: Brian King; linux-scsi@vger.kernel.org
> Subject: Re: Recommended HBA management interfaces
> 
> 
> 
> Mukker, Atul wrote:
> > The management protocol involves significant amount of binary data
> transfer involving multiple applications, so sysfs and friends are not
> useful for this particular application. But I gather from your (and
> Brian's) email that mid-layer SG extension should be used for this
> particular purpose.
> >
> > As for asynchronous notifications, netlink seems to be the de-facto
> choice (or it's mid-layer extensions). But didn't you mention earlier,
> vmware would not support this?
> 
> I answered from a purely linux perspective.  VMware is not Linux. VMware
> attempts to emulate the linux driver/midlayer api's, but emulation is done
> in
> their own way, with their own semantics, for their own purposes.. Anyone
> that
> believes they just drop a linux driver into vmware and it works w/o change
> has
> a screw loose. It may appear to work, and some subsystems may be better
> than
> others, but there are very subtle and critical differences.  As for all
> the
> ancillary interfaces such as sysfs, sgio, and transports: a) they have a
> hard
> time keeping up with the pace of the linux kernel; b) many of the
> interfaces
> are anti their hypervisor management model. Dependence on user-space utils,
> sysfs, etc doesn't work with a cos-less environment.  Netlink and sockets
> opens up security holes, and hypervisor-level socket support brings all
> kinds
> of headaches and memory issues. Netlink is not supported. Sysfs isn't
> supported. Even portions of the transports/midlayer are only partially
> implemented.  Unfortunately, vmware interfaces need to be taken up with
> vmware.
> 
> -- james s
