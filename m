From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 01/06] mptfusion: Added new sysfs parameters for
 handle, sas_addr and handles
Date: Thu, 03 Feb 2011 11:34:03 -0600
Message-ID: <1296754443.3022.19.camel@mulgrave.site>
References: <20110203095925.GB23502@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39794 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756196Ab1BCReF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Feb 2011 12:34:05 -0500
In-Reply-To: <20110203095925.GB23502@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Thu, 2011-02-03 at 15:29 +0530, Kashyap, Desai wrote:
> New feature is added. sas_address, sad_device_hanlde and firmware id will be visible from 
> sysfs parameters.

Well, sas_address, no ... it's already part of the phy properties of the
sas transport class.

Why handle and firmware_id ... they're fairly irrelevant properties of
the internal firmware ... so what's the point in exposing them
externally?

James


