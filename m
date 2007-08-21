From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [RFC] FC transport: Disable LUN scanning from low level driver
Date: Tue, 21 Aug 2007 17:31:57 +0200
Message-ID: <20070821153157.GA11101@schmichrtp.de.ibm.com>
References: <20070820112121.GA1487@schmichrtp.de.ibm.com> <46CA3ACB.7070708@emulex.com> <20070821123640.GA4821@schmichrtp.de.ibm.com> <46CAE295.2050404@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:31976 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334AbXHUPd1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Aug 2007 11:33:27 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.13.8/8.13.8) with ESMTP id l7LFXPbW180618
	for <linux-scsi@vger.kernel.org>; Tue, 21 Aug 2007 15:33:25 GMT
Received: from d12av03.megacenter.de.ibm.com (d12av03.megacenter.de.ibm.com [9.149.165.213])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7LFXPu02265216
	for <linux-scsi@vger.kernel.org>; Tue, 21 Aug 2007 17:33:25 +0200
Received: from d12av03.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av03.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7LFXPOV005509
	for <linux-scsi@vger.kernel.org>; Tue, 21 Aug 2007 17:33:25 +0200
Content-Disposition: inline
In-Reply-To: <46CAE295.2050404@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org

On Tue, Aug 21, 2007 at 09:03:17AM -0400, James Smart wrote:

> Nit (but preferred) : change "no_target_scan" to "disable_target_scan".
> Otherwise, patch is good.

Ok. I will send the fixed version in a separate mail.

> Yep.  However, I don't agree with Hannes in this case.  Given that the
> firmware is already doing funky things to share the real adapter, I
> believe it (or the driver) should do the right thing in the LUN
> presentation to keep the system happy. But - I guess that's something
> for a different time.

Yes, i think it is better to fix the problems when they occur. Adapter
sharing in general works well.

Christof
