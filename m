From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Tue, 2 Dec 2003 10:22:01 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060ED88@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:64172 "EHLO AVEXCH01.qlogic.org")
	by vger.kernel.org with ESMTP id S263343AbTLBSVy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2003 13:21:54 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>, Jes Sorensen <jes@wildopensource.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, jbarnes@sgi.com, mdr@sgi.com

On Tuesday, December 02, 2003 1:51 AM, Jeremy Higdon wrote:

> On Tue, Dec 02, 2003 at 02:15:06AM -0800, Andrew Vasquez wrote:
> > 
> > Yes, in the Linux world, the NVRAM value is irrelevent -- the
> > driver will determine the ideal value based on the
> > sizeof(dma_addr_t).  I've already removed the NVRAM reads of the
> > host_p[] from qla2x00_nvram_config().
> 
> Okay, that sounds good.  Do I take this to mean that this whole
> block: ...  will be gone in the next update?
> 

Actually, the only host_p values that are relevent and used in the linux
qla driver are the following:

	ha->flags.disable_risc_code_load = ((nv->host_p[0] & BIT_4) ? 1 : 0);
	ha->flags.enable_lip_reset = ((nv->host_p[1] & BIT_1) ? 1 : 0);
	ha->flags.enable_lip_full_login = ((nv->host_p[1] & BIT_2) ? 1 : 0);
	ha->flags.enable_target_reset = ((nv->host_p[1] & BIT_3) ? 1 : 0);

I've removed references to the other members.

> When do you plan to make the next update available?
>

Thursday.

Regards,
Andrew Vasquez
