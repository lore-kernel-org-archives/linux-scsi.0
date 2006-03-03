From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Fri, 03 Mar 2006 17:12:06 +0100
Message-ID: <44086AD6.3060503@s5r6.in-berlin.de>
References: <20060303102603.87127.qmail@web31804.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:50701 "EHLO
	statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S932288AbWCCQhD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 11:37:03 -0500
In-Reply-To: <20060303102603.87127.qmail@web31804.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

Luben Tuikov wrote:
> --- Mike Anderson <andmike@us.ibm.com> wrote:
>> The issue also results in the device discovery not completing by the time
>> the module load completes resulting in the initrd not finding the boot
>> disk http://bugzilla.kernel.org/show_bug.cgi?id=6045
> 
> They are not wed.
[...]
> The boot device may not
> be accessible right away, the kernel may need to wait for it to become
> available.  This will be more and more true in the future with more exotic
> protocols and infrastructures.

More precisely, the _BIOS_ or an equivalent has to wait for the _boot_
device (to load the kernel from). The _kernel_ has to wait for the
device carrying the _initial root filesystem_.

If the final working root filesystem resides on a device or network
resource which is more or less slow to be discovered, a minimal initial
root filesystem is put onto a RAM disk which is loaded together with the
kernel (a.k.a. an initrd).
-- 
Stefan Richter
-=====-=-==- --== ---==
http://arcgraph.de/sr/
