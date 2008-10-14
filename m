From: Abhijit Paithankar <apaithan@akamai.com>
Subject: Re: LSISAS1068 ioerr_cnt 0x1 on clean boot up
Date: Mon, 13 Oct 2008 19:56:51 -0700
Message-ID: <20081014025651.GB10518@akamai.com>
References: <20081009005126.GA7954@akamai.com> <6A4D764DC1BDE14495DA8DC60A3D69531F8DA6506F@hkgmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prod-mail-xrelay04.akamai.com ([72.246.198.135]:42910 "EHLO
	prod-mail-xrelay04.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755384AbYJNDFD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Oct 2008 23:05:03 -0400
Content-Disposition: inline
In-Reply-To: <6A4D764DC1BDE14495DA8DC60A3D69531F8DA6506F@hkgmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>

* Prakash, Sathya (Sathya.Prakash@lsi.com) wrote:
> I found the reason for the non zero err_cnt for SATA drives attached to mptsas.
> It is due to the failure in sending mode sense request for page 0x19 from mptsas driver for SATA drives (which is not supported by MPTSAS controller).

I see the same problem with LSI53C1030 with SCSI disks attached. So it
might not be a SATA-only problem.

Thanks!
Abhijit

