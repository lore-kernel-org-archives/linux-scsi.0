From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 0/5] zfcp: print S_ID and D_ID with 3 bytes
Date: Tue, 08 May 2007 09:26:05 -0500
Message-ID: <1178634365.3737.6.camel@mulgrave.il.steeleye.com>
References: <200705081114.41970.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:52469 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967567AbXEHO0m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 10:26:42 -0400
In-Reply-To: <200705081114.41970.swen@vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Swen Schillig <swen@vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

On Tue, 2007-05-08 at 11:14 +0200, Swen Schillig wrote:
> From: Christof Schmitt <christof.schmitt@de.ibm.com>
> 
> S_ID and D_ID are defined in the FCP spec as 3 byte fields.
> Change the output in zfcp print statements accordingly to print
> them with only 3 bytes.

For future reference, if you send out a [PATCH 0/N] it typically
contains a description of the patches that are coming, not a patch
itself ... Having six patches numbered 0 to 5 out of 5 is somewhat
confusing ...

James


