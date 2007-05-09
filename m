From: linas@austin.ibm.com (Linas Vepstas)
Subject: Re: [PATCH 2/2]: PCI Error Recovery: Symbios SCSI First Failure
Date: Wed, 9 May 2007 15:26:21 -0500
Message-ID: <20070509202621.GA4452@austin.ibm.com>
References: <20070420204114.GL31947@austin.ibm.com> <20070420204720.GM31947@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:36751 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbXEIU0Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2007 16:26:25 -0400
Content-Disposition: inline
In-Reply-To: <20070420204720.GM31947@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linuxppc-dev@ozlabs.org, linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Hi Matthew,

I had been hoping these patches might make it into 2.6.22,
... this is a nag note; please forward upstream.

--linas

On Fri, Apr 20, 2007 at 03:47:20PM -0500, Linas Vepstas wrote:
> 
> Implement the so-called "first failure data capture" (FFDC) for the
> symbios PCI error recovery.  After a PCI error event is reported,
> the driver requests that MMIO be enabled. Once enabled, it 
> then reads and dumps assorted status registers, and concludes
> by requesting the usual reset sequence.
> 
> (includes a whitespace fix for bad indentation).
> 
> Signed-off-by: Linas Vepstas <linas@austin.ibm.com>
