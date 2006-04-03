From: "Tarte, Robert" <Robert_Tarte@adaptec.com>
Subject: RE: SATA support in aic94xx
Date: Sun, 2 Apr 2006 20:57:58 -0700
Message-ID: <89FD792A883D4B47AD469FEA2E5D1F9B17F916@aime2k302.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:18048 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S932276AbWDCD6E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Apr 2006 23:58:04 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mda2376 <mda2376@gmail.com>, linux-scsi@vger.kernel.org

> Subject: SATA support in aic94xx
> 
> I have an Adaptec AIC-9410W SAS/SATA Host Adapter integrated on a new
> server motherboard with 4 SATA disc's attached. I'm trying to use the
> aic94xx driver and haven't had any success with it recognizing the
> drives. All 4 drives are detected in the Adaptec BIOS. I've tried both
> the 2.6.13-sas kernel available from Adaptec's website and the support
> available in 2.6.16-mm2. The controller is recognized by the kernel
> but does not detect any of the SATA discs.
> 
> I see that this driver is still under development but I am curious if
> support for SATA discs is available, or if there is anything else I
> can try? My dmesg output with aic94xx compiled in debug mode is
> attached if this would be helpful.

The aic94xx driver does not currently support SATA, but the adp94xx
driver does.  The adp94xx driver is a transitional AIC-9410W driver for
2.6 and the only driver available for the 2.4 kernel.  I'll try to
figure out where it is on the Adaptec web site ...

Rob
