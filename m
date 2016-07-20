From: Michael Ellerman <patch-notifications@ellerman.id.au>
Subject: Re: [v2] cxl: remove dead Kconfig options
Date: Wed, 20 Jul 2016 19:10:22 +1000 (AEST)
Message-ID: <3rvWMz2vPGz9t0t@ozlabs.org>
References: <1468817577-1843-1-git-send-email-andrew.donnellan@au1.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:34089 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbcGTJKZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2016 05:10:25 -0400
In-Reply-To: <1468817577-1843-1-git-send-email-andrew.donnellan@au1.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Donnellan <andrew.donnellan@au1.ibm.com>, linuxppc-dev@lists.ozlabs.org
Cc: clombard@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, mrochs@linux.vnet.ibm.com, fbarrat@linux.vnet.ibm.com, manoj@linux.vnet.ibm.com, imunsie@au1.ibm.com

On Mon, 2016-18-07 at 04:52:57 UTC, Andrew Donnellan wrote:
> Remove the CXL_KERNEL_API and CXL_EEH Kconfig options, as they were only
> needed to coordinate the merging of the cxlflash driver. Also remove the
> stub implementation of cxl_perst_reloads_same_image() in cxlflash which is
> only used if CXL_EEH isn't defined (i.e. never).
> 
> Suggested-by: Ian Munsie <imunsie@au1.ibm.com>
> Signed-off-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
> Acked-by: Ian Munsie <imunsie@au1.ibm.com>
> Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/1e44727a0b220f6ead12fefcff

cheers
