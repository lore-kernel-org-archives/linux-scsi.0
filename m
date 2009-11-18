From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [patch 12/18] st: fix test of value range in st_set_options()
Date: Wed, 18 Nov 2009 23:57:32 +0200 (EET)
Message-ID: <alpine.LNX.2.00.0911182356470.13484@kai.makisara.local>
References: <200911172253.nAHMrMHU019953@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:57366 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151AbZKRV5o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2009 16:57:44 -0500
In-Reply-To: <200911172253.nAHMrMHU019953@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, roel.kluin@gmail.com, osst@riede.org

On Tue, 17 Nov 2009, akpm@linux-foundation.org wrote:

> From: Roel Kluin <roel.kluin@gmail.com>
> 
> value cannot logically be less than START and greater than BUFFERSIZE.
> 
> #define EXTENDED_SENSE_START  18
> 
> // vi include/scsi/scsi_cmnd.h +105
> #define SCSI_SENSE_BUFFERSIZE 	96
> 
> [akpm@linux-foundation.org: fix warning]
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> Cc: Willem Riede <osst@riede.org>
> Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
Acked-by: Kai Makisara <kai.makisara@kolumbus.fi>

