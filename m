From: Louis-David Mitterrand <vindex+lists-linux-scsi@apartia.org>
Subject: Re: using a PERC6/i (MegaRaid SAS 1078) in JBOD mode?
Date: Mon, 25 Oct 2010 16:09:05 +0200
Message-ID: <20101025140905.GA20569@apartia.fr>
References: <20101023095816.GA19791@apartia.fr>
 <4B6A08C587958942AA3002690DD4F8C3010111F73E@cosmail02.lsi.com>
 <20101025131937.GA6605@apartia.fr>
 <20101025154705.73d49860@harpe.intellique.com>
 <20101025135647.GA14302@apartia.fr>
 <4B6A08C587958942AA3002690DD4F8C3010111F771@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zenon.apartia.fr ([82.66.93.83]:58485 "EHLO zenon.apartia.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755749Ab0JYOJH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2010 10:09:07 -0400
Received: from sylla.apartia.fr (sylla.apartia.fr [10.0.3.3])
	by zenon.apartia.fr (Postfix) with ESMTP id EDB7F424A6009
	for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2010 16:09:05 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3010111F771@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Oct 25, 2010 at 08:02:22AM -0600, Yang, Bo wrote:
> You also can use ctrl^H during the controller post to configure the JBOD.  

Unfortuntely I found no way to configure disks in JBOD mode through the
adapter bios. A google search seems to indicate other users have the
same problem.

Apparently a firmware change (to "initiator and target" mode) is
required to turn that adapter's into a simple non-raid SATA controller
but I couldn't find it anywhere.

Any idea?
