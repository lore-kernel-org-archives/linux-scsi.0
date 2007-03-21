From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid: cleanup and version stamp driver
Date: Wed, 21 Mar 2007 15:10:56 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF0172BEF4@otce2k301.adaptec.com>
References: <46017E56.4070605@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:52018 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933727AbXCUTK6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Mar 2007 15:10:58 -0400
Content-class: urn:content-classes:message
In-Reply-To: <46017E56.4070605@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Because Adaptec Policy requires me to send all email through Outlook ...

Outlook has demonstrated that it will change text, either as inlined or
as an attachment, into something that is not a functional patch. Years
of sending patches to Mark Haverkamp have tuned me to send them this way
to ensure accuracy of delivery. I understand that my procedures may need
to be changed, waivers requested perhaps, as I issue the patches
directly to the list now that OSDL has had to deal with reductions in
finances and force and I will take your comment to heart.

Sorry for any inconvenience when trying to view the content of the
patch.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Boaz Harrosh [mailto:bharrosh@panasas.com] 
> Sent: Wednesday, March 21, 2007 2:50 PM
> To: Salyzyn, Mark
> Cc: linux-scsi
> Subject: Re: [PATCH] aacraid: cleanup and version stamp driver
> 
> 
> Salyzyn, Mark wrote:
> > There is some residual cleanup of the last series of patches and the
> > need to bump the revision number to draw the line in the sand.
> > 
> > The cmd->SCp.phase is set in the aac_valid_context routine, then set
> > again to the same value following it's return. The 
> cmd->scsi_done is set
> > twice in the aac_queuecommand routine. Free up the scsidev FILO in
> > aac_probe_container as it is not needed further down the 
> function in any
> > case. Improve the efficiency of the abort handler kernel print
> > parameters. Bump revision number of driver to approximate 
> the equivalent
> > in the Adaptec supplied version.
> > 
> > This attached patch is against current scsi-misc-2.6
> > 
> > Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
> > 
> > ---
> > 
> > Sincerely -- Mark Salyzyn
> 
> looking in mail source
> 
> > This attached patch is against current scsi-misc-2.6
> > 
> > Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
> > 
> > ---
> > 
> > Sincerely -- Mark Salyzyn
> > 
> > ------_=_NextPart_001_01C76BE1.51493AEC
> > Content-Type: application/octet-stream;
> > 	name="aacraid_cleanup_and_version.patch"
> > Content-Transfer-Encoding: base64
> > Content-Description: aacraid_cleanup_and_version.patch
> > Content-Disposition: attachment;
> > 	filename="aacraid_cleanup_and_version.patch"
> > 
> > 
> ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaX
> ZlcnMvc2NzaS9h
> > 
> YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2
> hiYS5jCTIwMDct
> > 
> MDMtMjEgMTM6MjM6MTkuMzQ1MjYwNzAyIC0wNDAwCisrKyBiL2RyaXZlcnMvc2
> NzaS9hYWNyYWlk
> > 
> L2FhY2hiYS5jCTIwMDctMDMtMjEgMTM6Mzc6MzIuOTk1NDA4MDEwIC0wNDAwCk
> BAIC0zNjUsNyAr
> > 
> MzY1LDYgQEAKIAlzdHJ1Y3Qgc2NzaV9jbW5kICogc2NzaWNtZDsKIAogCXNjc2
> ljbWQgPSAoc3Ry
> 
> why is the text attachment marked "Content-Type: 
> application/octet-stream"
> and encoded? attachments are OK but why not plain text?
> 
> Boaz
> 
> 
> 
