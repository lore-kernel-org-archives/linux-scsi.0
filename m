From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: scsi compliance tests?
Date: Wed, 7 May 2003 19:39:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030507193913.A8226@beaverton.ibm.com>
References: <3EB9B543.7000003@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-218-173.dsl.aracnet.com ([216.99.218.173]:11254 "EHLO
	laptop") by vger.kernel.org with ESMTP id S261842AbTEHCca (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 May 2003 22:32:30 -0400
Content-Disposition: inline
In-Reply-To: <3EB9B543.7000003@pobox.com>; from jgarzik@pobox.com on Wed, May 07, 2003 at 09:39:15PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Wed, May 07, 2003 at 09:39:15PM -0400, Jeff Garzik wrote:

> Are there any publicly available tools that can be used to test/validate 
> the compliance of a SCSI device, as exported via the standard Linux 
> kernel SCSI layer?

I don't know of any.

> I'm writing a low-level SCSI driver for Linux, that is essentially a 
> SCSI simulator, or translator.

Like the scsi_debug driver? It is generally a linux SCSI pseudo driver,
creating SCSI disks on top of physical memory. Or are you creating
something more useful?

-- Patrick Mansfield
