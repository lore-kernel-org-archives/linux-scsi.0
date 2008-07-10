From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: Fix for problems introduced by enabling MSI by default for MPT
	SPI controllers
Date: Thu, 10 Jul 2008 08:56:27 -0500
Message-ID: <1215698187.3353.13.camel@localhost.localdomain>
References: <6A4D764DC1BDE14495DA8DC60A3D69531E95D72405@hkgmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53719 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755125AbYGJN4a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2008 09:56:30 -0400
In-Reply-To: <6A4D764DC1BDE14495DA8DC60A3D69531E95D72405@hkgmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>

On Thu, 2008-07-10 at 16:38 +0800, Prakash, Sathya wrote:
> We have some known cases of MSI not working with FC and SPI controllers, that is the reason we don't want to enable the MSI for them by default.

Is that because of motherboard problems or because of actual on board
issues with the fusion controller?

James


