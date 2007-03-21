From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] aacraid: cleanup and version stamp driver
Date: Wed, 21 Mar 2007 20:49:58 +0200
Message-ID: <46017E56.4070605@panasas.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF0172BE93@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:57593 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933673AbXCUTGk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Mar 2007 15:06:40 -0400
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF0172BE93@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Salyzyn, Mark wrote:
> There is some residual cleanup of the last series of patches and the
> need to bump the revision number to draw the line in the sand.
> 
> The cmd->SCp.phase is set in the aac_valid_context routine, then set
> again to the same value following it's return. The cmd->scsi_done is set
> twice in the aac_queuecommand routine. Free up the scsidev FILO in
> aac_probe_container as it is not needed further down the function in any
> case. Improve the efficiency of the abort handler kernel print
> parameters. Bump revision number of driver to approximate the equivalent
> in the Adaptec supplied version.
> 
> This attached patch is against current scsi-misc-2.6
> 
> Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
> 
> ---
> 
> Sincerely -- Mark Salyzyn

looking in mail source

> This attached patch is against current scsi-misc-2.6
> 
> Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
> 
> ---
> 
> Sincerely -- Mark Salyzyn
> 
> ------_=_NextPart_001_01C76BE1.51493AEC
> Content-Type: application/octet-stream;
> 	name="aacraid_cleanup_and_version.patch"
> Content-Transfer-Encoding: base64
> Content-Description: aacraid_cleanup_and_version.patch
> Content-Disposition: attachment;
> 	filename="aacraid_cleanup_and_version.patch"
> 
> ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
> YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDct
> MDMtMjEgMTM6MjM6MTkuMzQ1MjYwNzAyIC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
> L2FhY2hiYS5jCTIwMDctMDMtMjEgMTM6Mzc6MzIuOTk1NDA4MDEwIC0wNDAwCkBAIC0zNjUsNyAr
> MzY1LDYgQEAKIAlzdHJ1Y3Qgc2NzaV9jbW5kICogc2NzaWNtZDsKIAogCXNjc2ljbWQgPSAoc3Ry

why is the text attachment marked "Content-Type: application/octet-stream"
and encoded? attachments are OK but why not plain text?

Boaz


