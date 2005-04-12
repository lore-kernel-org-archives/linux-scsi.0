From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [patch 062/198] ahci: AHCI mode SATA patch for Intel ESB2
Date: Tue, 12 Apr 2005 14:32:03 -0400
Message-ID: <20050412183203.GA16564@havoc.gtf.org>
References: <200504121031.j3CAVexS005372@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlmail.prod.rxgsys.com ([64.74.124.160]:61158 "EHLO
	bastet.signetmail.com") by vger.kernel.org with ESMTP
	id S262407AbVDLScR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2005 14:32:17 -0400
Content-Disposition: inline
In-Reply-To: <200504121031.j3CAVexS005372@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org, jason.d.gaston@intel.com, linux-scsi@vger.kernel.org

On Tue, Apr 12, 2005 at 03:31:34AM -0700, akpm@osdl.org wrote:
> 
> From: Jason Gaston <jason.d.gaston@intel.com>
> 
> This patch adds the Intel ESB2 DID's to the ahci.c file for AHCI mode SATA
> support.

Please don't send libata stuff directly to Linus.

Even a patch that appears as simple as this has complications:
The Intel ICH7 combined mode still needs sorting out; combined mode and
another BIOS option (IDE/AHCI) can change the PCI IDs that the
southbridge exports.

I don't want to commit support for -half- the configurations, which
oh-by-the-way will fail if even those users tweak the BIOS options.

	Jeff



