From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: megaraid bug in kobject_register when no device is present
Date: Thu, 9 Feb 2006 12:14:12 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C265142063@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:65019 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750717AbWBITOT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Feb 2006 14:14:19 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>, Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Hi,

On Thursday, February 09, 2006 11:26 AM Greg KH wrote:
> This means that the driver is trying to register with the same name as
> another driver on the same bus.
It has been duplicated and made change in megaraid legacy driver.
The module name for the driver will be 'megaraid_legacy' from 'megaraid'.
Patch will be followed soon.

Thank you,

Seokmann
