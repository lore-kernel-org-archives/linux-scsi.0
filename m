From: "Moore, Eric Dean" <emoore@lsil.com>
Subject: RE: [PATCH] MPT Fusion driver update
Date: Mon, 10 Nov 2003 10:17:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57035A9E21@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:18876 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S263918AbTKJPRr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2003 10:17:47 -0500
Received: from mhbs.lsil.com (mhbs.lsil.com [147.145.31.100])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id hAAF4Enf009100
	for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2003 07:15:21 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Christoph,

Can you let me know what the *real problems* are with the
driver. This patch was mostly cosmetic. It was only fixing
problems unloading/reloading the IOCTL driver.  I'm new to
handling this driver, and I would like to know what the
outstanding issues are. Thanks.

In addition, its going to be very difficult to 
inline source into email clients. The problem that I see
are the tabs and over 80 characters per line. I've tried 
a handful of email clients, non work. So I decided to 
email James Bottomley the patch as an attachment.  When Pam
Delaney was supporting this driver, she was directly
emailing patches to Alan Cox, etc.  I can email you 
the patch or put in on our ftp so you can download. 

Eric 


On Saturday, November 08, 2003 1:34 AM, Christoph Hellwig wrote:
> On Fri, Nov 07, 2003 at 09:38:25AM -0600, James Bottomley wrote:
> > This one's from: Eric Moore <emoore@lsil.com>
> > 
> > Changes in patch
> > * removed __init from mptscsih_setup
> > * removed __init from get_setup_token
> > * changed copyright from 2002 to 2003
> > * added new mailto, and removed Pam.Delaney
> > * added some fix for 32bit emulation when unloading mptctl module
> 
> The patch doesn't look bad but doesn't fix the real problems 
> the driver
> has either..
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
