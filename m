From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Open-FCoE] [v2 PATCH 4/5] bnx2fc: Broadcom FCoE Offload driver
 submission - part 2
Date: Thu, 03 Feb 2011 15:26:31 -0600
Message-ID: <4D4B1D87.8030806@cs.wisc.edu>
References: <1293170555.4676.574.camel@ltsjc-bprakash2.corp.ad.broadcom.com> <4D316634.5030300@cs.wisc.edu> <1295311066.3536.105.camel@ltsjc-bprakash2.corp.ad.broadcom.com> <4D4922BE.40907@cs.wisc.edu> <1296704558.268.552.camel@LTLNR-SJCE10.corp.ad.broadcom.com> <4D4A29A1.7010105@cs.wisc.edu> <4D4A3374.4010306@cs.wisc.edu> <1296716694.268.643.camel@LTLNR-SJCE10.corp.ad.broadcom.com> <4D4B165E.2010805@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36889 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab1BCV0P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Feb 2011 16:26:15 -0500
In-Reply-To: <4D4B165E.2010805@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>
Cc: james.smart@emulex.com, andrew.vasquez@qlogic.com, robert.w.love@intel.com, "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 02/03/2011 02:55 PM, Mike Christie wrote:
> 1. For issue of sending aborts after resets, it seems we need to do
> this. libfc needs this fixed. Maybe qlogic does too (if the firmware
> does not do this then the driver needs code added). I think bfa does too
> if it does not do it in firmware (did not see any code for it in driver).

Oh yeah, forgot fnic and ibmvfc might need this too if the firmware does 
not do it. I guess only lpfc did aborts after resets (at least in the 
driver code).
