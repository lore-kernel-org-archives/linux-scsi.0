From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: ATA Information VPD page, minor
Date: Tue, 04 Oct 2005 07:41:12 -0400
Message-ID: <43426A58.6080708@pobox.com>
References: <432E9326.10206@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:44454 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932247AbVJDLlP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2005 07:41:15 -0400
In-Reply-To: <432E9326.10206@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, htejun@gmail.com

Douglas Gilbert wrote:
> Jeff,
> Here is a small followup patch for the ATA Information
> VPD page.
> 
> Changelog:
>   - add entry for ATA information VPD page [0x89] in the
>     Supported VPD pages VPD page [0x0]

Obviously OK.  Please incorporate this into the previous ATA Info VPD 
page patch.

	Jeff



