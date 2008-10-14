From: Abhijit Paithankar <apaithan@akamai.com>
Subject: Re: LSISAS1068 ioerr_cnt 0x1 on clean boot up
Date: Tue, 14 Oct 2008 11:43:16 -0700
Message-ID: <20081014184316.GC20297@akamai.com>
References: <20081014025504.GA10518@akamai.com> <6A4D764DC1BDE14495DA8DC60A3D69531F8DA650E9@hkgmail01.lsi.com> <20081014174924.GA20297@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prod-mail-xrelay03.akamai.com ([72.247.150.167]:57397 "EHLO
	prod-mail-xrelay03.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479AbYJNSnR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Oct 2008 14:43:17 -0400
Content-Disposition: inline
In-Reply-To: <20081014174924.GA20297@akamai.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, Douglas Gilbert <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Please ignore this email.

* Abhijit Paithankar (apaithan@akamai.com) wrote:
> We shouldn't be sending the port mode page request for SATA devices as
> well.
> 
> That was clear from the tests I ran yesterday.
> 
> So I think (SAS_PROTOCOL_SATA | SAS_PROTOCOL_SSP) is required.
> 
> Thanks!
> Abhijit
