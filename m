From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/5] aic94xx: plumb in I_T_nexus_reset task management
	function
Date: Sun, 24 Feb 2008 00:01:25 -0600
Message-ID: <1203832885.3139.33.camel@localhost.localdomain>
References: <1203831446.3139.21.camel@localhost.localdomain>
	 <47C105FB.8090401@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51652 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757006AbYBXGBa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Feb 2008 01:01:30 -0500
In-Reply-To: <47C105FB.8090401@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Darrick J. Wong" <djwong@us.ibm.com>

On Sun, 2008-02-24 at 00:51 -0500, Jeff Garzik wrote:
> Tangent:
> 
> Now that patches for ipr and sata_sx4 exist, libsas is the last holdout 
> using libata's old error handling paths.
> 
> I think Darrick was either scoping that work, or had preliminary patches?
> 
> Anyway, that's holding back removal of a lot of libata code, so I wanted 
> to make sure the issue remained in people's minds...

I've not really been following what the issue actually is, so hopefully
Darrick has.

At the moment, we don't use any of libata for error handling in libsas.
(In fact, there's a big issue with ATA error handling in libsas in
general, since the sequencer abort task doesn't know what to do with a
task that's at an ATA drive ... we need to detect that condition and
then apply the SATL abort function, which depends on whether we're NCQ
or not...SATA error handling was next on my list of things to look at).

James

