From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] qla2xxx: Add iIDMA support.
Date: Tue, 10 Oct 2006 10:29:58 +0100
Message-ID: <20061010092958.GB395@infradead.org>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local> <115981565078-git-send-email-andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:54964 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965128AbWJJJaA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 05:30:00 -0400
Content-Disposition: inline
In-Reply-To: <115981565078-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>

On Mon, Oct 02, 2006 at 12:00:43PM -0700, Andrew Vasquez wrote:
> iIDMA (Intelligent Interleaved Direct Memory Access) allows for
> the HBA hardware to send FC frames at the rate at which they can
> be received by a target device.  By taking advantage of the
> higher link rate, the HBA can maximize bandwidth utilization in a
> heterogeneous multi-speed SAN.
> 
> Within a fabric topology, port speed detection is done via a Name
> Server command (GFPN_ID) followed by a Fabric Management command
> (GPSC).  In an FCAL/N2N topology, port speed is based on the HBA
> link-rate.

Looks good to me.

