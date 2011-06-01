From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] libsas: add SMP READ/WRTIE GPIO support
Date: Wed, 01 Jun 2011 10:32:24 -0400
Message-ID: <4DE64D78.6090309@interlog.com>
References: <20110601140203.26324.22849.stgit@gklab-128-184.igk.intel.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:46434 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756774Ab1FAOcs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jun 2011 10:32:48 -0400
In-Reply-To: <20110601140203.26324.22849.stgit@gklab-128-184.igk.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Artur Wojcik <artur.wojcik@intel.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On 11-06-01 10:02 AM, Artur Wojcik wrote:
> This patch enables the SMP READ/WRITE GPIO function interface in libsas SMP
> host module. The interface is used to control the SGPIO initiator in the SAS
> initiator. The implementation is SFF-8485 and SAS-2 compliant.
>
> There are two functions in transport class only responsible for reading and
> writting GPIO registers. I decided to leave the decission about what type of
> registers are supported to lldd.
>
> Now the user space application may issue SMP READ/WRITE GPIO frame to HBA in
> order to read/write GPIO registers.

Your code also accepts the somewhat mysterious READ GPIO
REGISTER ENHANCED SMP function and its WRITE equivalent.
Reference is made in sas2r16.pdf to SFF-8485 for those
functions. However the most recent version of SFF-8485
on the Seagate site is 0.7 dated February 2006, and it does
not define those ENHANCED functions.

Could you tell us what those ENHANCED versions do?

Doug Gilbert
