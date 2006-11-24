From: Ben Collins <ben.collins@ubuntu.com>
Subject: Re: [PATCH] scsi/initio: section mismatches with HOTPLUG=n
Date: Fri, 24 Nov 2006 18:10:59 -0500
Message-ID: <1164409859.5257.7.camel@gullible>
References: <20061119185343.e4dde647.randy.dunlap@oracle.com>
	 <1164408696.2813.19.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adelie.ubuntu.com ([82.211.81.139]:34240 "EHLO
	adelie.ubuntu.com") by vger.kernel.org with ESMTP id S966259AbWKXXLH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Nov 2006 18:11:07 -0500
In-Reply-To: <1164408696.2813.19.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>

On Fri, 2006-11-24 at 16:51 -0600, James Bottomley wrote:
> On Sun, 2006-11-19 at 18:53 -0800, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > WARNING: drivers/scsi/initio.o - Section mismatch: reference to .init.data: from .text between 'i91u_detect' (at offset 0x26e8) and 'i91uSCBPost'
> > WARNING: drivers/scsi/initio.o - Section mismatch: reference to .init.data:i91u_pci_devices from .text between 'i91u_detect' (at offset 0x26ef) and 'i91uSCBPost'
> 
> Hmm, this apparently got into the tree unreviewed via Ben Collins:
> 
> commit 012887327875915f76a6208e81fe0d67a682ec15
> Author: Ben Collins <bcollins@ubuntu.com>
> Date:   Wed Oct 18 08:40:57 2006 -0400
> 
>     [initio] Add pci dev table for module auto loading.
>     
>     Signed-off-by: Ben Collins <bcollins@ubuntu.com>
> 
> Ben, for future reference, would you send SCSI patches over the SCSI
> list, please.  Secondly, do you intend to complete this change?  What
> Randy proposes will restore the driver to its original state.  However,
> it could also be fixed properly by adding __devinit to all the relevant
> PCI initialisation routines, which would be preferable.

The patch went in with about half a dozen others for similar changes, so
it was a group set.

Sorry about the mismatches. I've only been building with HOTPLUG=y.

I can do a patch if you want, just let me know.
