From: Abhijit Paithankar <apaithan@akamai.com>
Subject: Re: LSISAS1068 ioerr_cnt 0x1 on clean boot up
Date: Tue, 14 Oct 2008 10:49:24 -0700
Message-ID: <20081014174924.GA20297@akamai.com>
References: <20081014025504.GA10518@akamai.com> <6A4D764DC1BDE14495DA8DC60A3D69531F8DA650E9@hkgmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prod-mail-xrelay01.akamai.com ([72.246.2.12]:40561 "EHLO
	prod-mail-xrelay01.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750766AbYJNRt0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2008 13:49:26 -0400
Content-Disposition: inline
In-Reply-To: <6A4D764DC1BDE14495DA8DC60A3D69531F8DA650E9@hkgmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, Douglas Gilbert <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

* Prakash, Sathya (Sathya.Prakash@lsi.com) wrote:
> This patch will avoid sending the  port mode page request for SSP device also so NACK. Try to use the patch provided by Eric, which modifies the driver to send the port mode page request only for SSP device.

We shouldn't be sending the port mode page request for SATA devices as
well.

That was clear from the tests I ran yesterday.

So I think (SAS_PROTOCOL_SATA | SAS_PROTOCOL_SSP) is required.

Thanks!
Abhijit
