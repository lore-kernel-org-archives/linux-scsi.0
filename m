From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: Adding transport attributes to qla1280
Date: Wed, 15 Sep 2004 09:55:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0DD04B7@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:12993 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S266539AbUIOQ7s convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 12:59:48 -0400
Content-Class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jeremy Higdon <jeremy@classic.engr.sgi.com>, Jes Sorensen <jes@wildopensource.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


On Wednesday, September 15, 2004 8:39 AM, James Bottomley wrote:
> 
> I've run into rather a nasty problem in the qla1280 drivers to do
> with transport attributes.  My plan, if I can get settable
> attributes to work, is to convert it over to the SPI transport class
> and pull in domain validation for free. 
> 
> The problem is that the API in the driver for setting attributes:
> qla1280_set_target_parameters() doesn't seem to work ... at least it
> does apparently set the parameters using a qla1280 mailbox command,
> and if I read them back again with the other command, it confirms
> the setting.  However, the next attempt to access the device hangs
> the entire system. 
> 
> My deduction from all of this is that the HBA is changing the
> transfer settings on its side but not renegotiating those new
> settings with the device.  However, without a bus analyser, I can't
> be sure I'm correct.
> 

I'll ping locally for some information.

> So, since this entire HBA is one of the magic ones that runs in
> proprietary firmware and has no documentation even for the mailbox
> command interface, could someone who has access to the secret
> documents look in them and tell me how I can do this?
> 
> Alternatively, actually releasing the specs for what are now at
> least 4 year old chips would be a very nice gesture on the part of
> Qlogic.
> 

Christophe had expressed interest some time ago for QLogic SCSI specs.
I've been trying to negotiate with locals here at QLogic for the
specs. release.

--
AV
