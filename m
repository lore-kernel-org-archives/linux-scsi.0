From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Fri, 3 Mar 2006 02:26:03 -0800 (PST)
Message-ID: <20060303102603.87127.qmail@web31804.mail.mud.yahoo.com>
References: <20060302231323.GA12869@us.ibm.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31804.mail.mud.yahoo.com ([68.142.207.67]:11647 "HELO
	web31804.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1751494AbWCCK0E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 05:26:04 -0500
In-Reply-To: <20060302231323.GA12869@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

--- Mike Anderson <andmike@us.ibm.com> wrote:
> The issue also results in the device discovery not completing by the time
> the module load completes resulting in the initrd not finding the boot
> disk http://bugzilla.kernel.org/show_bug.cgi?id=6045

They are not wed.

When loading the SAS stack, you're just loading an abstraction,
a service, a management layer.

When loading the aic94xx LLDD, you're just loading a PCI device driver
which happens to have a specific purpose which is to give you an interface
to the Service Delivery Subsystem (of SAS).

> I agree that we need a solution for this. Should the solution be in the
> LLDDs.I thought previous comments was that we wanted this fixed outside
> the kernel in user space. Though I have not seen any enabled support in
> initrds or support in the initrd bins.
> 
> This appears to not only be an issue with aic94xx as it appears this could
> happen with some of the fc transport LLDDs.

Indeed, the world of storage is changing tradition.  The boot device may not
be accessible right away, the kernel may need to wait for it to become
available.  This will be more and more true in the future with more exotic
protocols and infrastructures.


