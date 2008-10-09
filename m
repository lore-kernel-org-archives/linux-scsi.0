From: Abhijit Paithankar <apaithan@akamai.com>
Subject: Re: LSISAS1068 ioerr_cnt 0x1 on clean boot up
Date: Wed, 8 Oct 2008 17:51:26 -0700
Message-ID: <20081009005126.GA7954@akamai.com>
References: <20081007014608.GA28229@apaithan-desktop.sanmateo.corp.akamai.com> <6A4D764DC1BDE14495DA8DC60A3D69531E967A073C@hkgmail01.lsi.com> <20081007233700.GA6439@apaithan-desktop.sanmateo.corp.akamai.com> <48EC9105.2070604@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:59180 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752534AbYJIBAD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Oct 2008 21:00:03 -0400
Content-Disposition: inline
In-Reply-To: <48EC9105.2070604@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>

* Douglas Gilbert (dgilbert@interlog.com) wrote:
>
> IMO it is not an error for the host to receive such UAs just
> after power up, and soon thereafter. It is potentially an error
> to have such UAs while a partition on a LU within a target is
> mounted. But the SCSI subsystem is not aware of mounts. Perhaps
> there should be a separate counter (i.e. other than ioerr_cnt) for
> UAs associated with hard resets.

If a hard reset is part of routine initialization at power-on, then
it is not an error and the MPT driver should not tell the scsi
mid-layer that an error happened.

Thanks!
Abhijit
