From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mptsas: Added code for checking the LU type is SSC for
 SILI bit in READ_6  and READ_16 CDB
Date: Fri, 02 Mar 2012 10:03:15 -0600
Message-ID: <1330704195.2786.34.camel@dabdike.int.hansenpartnership.com>
References: <201203020956.q229uGR2002732@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53418 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751156Ab2CBQDR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Mar 2012 11:03:17 -0500
In-Reply-To: <201203020956.q229uGR2002732@milmhbs0.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nagalakshmi.nandigama@lsi.com
Cc: stable@vger.kernel.org, linux-scsi@vger.kernel.org, jejb@kernel.org

On Fri, 2012-03-02 at 15:26 +0530, nagalakshmi.nandigama@lsi.com wrote:
> Added code for checking the LU type is SSC for SILI bit in READ_6  and
> READ_16 CDB 
> 
> Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>

The description doesn't give me the impression that this is a bug
fix ... is this a bug fix and if so, what bug is being fixed (describe
the user visible issue)?

James


