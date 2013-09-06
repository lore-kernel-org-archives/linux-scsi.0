From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/6] scsi: ufs: add unipro attribute IDs
Date: Fri, 06 Sep 2013 16:14:34 -0700
Message-ID: <1378509274.2063.47.camel@dabdike.int.hansenpartnership.com>
References: <1377965424-30991-1-git-send-email-santoshsy@gmail.com>
	 <1377965424-30991-5-git-send-email-santoshsy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50728 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759Ab3IFXOg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 19:14:36 -0400
In-Reply-To: <1377965424-30991-5-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Seungwon Jeon <tgih.jun@samsung.com>

On Sat, 2013-08-31 at 21:40 +0530, Santosh Y wrote:
> From: Seungwon Jeon <tgih.jun@samsung.com>
> 
> 'drivers/scsi/ufs/unipro.h' is added.
> Attributes in the layers of the UNIPRO stack can be
> read and written via the DME.

A dangling unused header file is a bit of a strange commit.  I merged it
into the next one which actually uses the header.

James


