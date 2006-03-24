From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC PATCH 35/35] Add Xen virtual block device driver.
Date: Fri, 24 Mar 2006 08:37:15 -0500
Message-ID: <4423F60B.6020805@garzik.org>
References: <A95E2296287EAD4EB592B5DEEFCE0E9D4B9E8A@liverpoolst.ad.cl.cam.ac.uk>	 <4421D943.1090804@garzik.org> <1143202673.18986.5.camel@localhost.localdomain> <4423E853.1040707@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1422755AbWCXNha@vger.kernel.org>
In-Reply-To: <4423E853.1040707@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ian Pratt <m+Ian.Pratt@cl.cam.ac.uk>, Anthony Liguori <aliguori@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, Ian Pratt <ian.pratt@xensource.com>, ian.pratt@cl.cam.ac.uk, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> In fact, SCSI should make a few things easier, because the notion of 
> host+bus topology is already present, and notion of messaging is already 
> present, so you don't have to recreate that in a Xen block device 
> infrastructure.

Another benefit of SCSI:  when an IBM hypervisor in the Linux kernel 
switched to SCSI, that allowed them to replace several drivers (virt 
disk, virt cdrom, virt floppy?) with a single virt-SCSI driver.

	Jeff
