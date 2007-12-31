From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] libsas: don't use made up error codes
Date: Mon, 31 Dec 2007 13:25:53 -0800
Message-ID: <20071231212553.GD6767@tree.beaverton.ibm.com>
References: <1199039851.5380.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:51563 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbXLaV0F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Dec 2007 16:26:05 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lBVLQ3UI010405
	for <linux-scsi@vger.kernel.org>; Mon, 31 Dec 2007 16:26:03 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lBVLPw8U164512
	for <linux-scsi@vger.kernel.org>; Mon, 31 Dec 2007 14:26:03 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lBVLPvE1010972
	for <linux-scsi@vger.kernel.org>; Mon, 31 Dec 2007 14:25:58 -0700
Content-Disposition: inline
In-Reply-To: <1199039851.5380.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, Dec 30, 2007 at 12:37:31PM -0600, James Bottomley wrote:
> This is bad for two reasons:
> 
>      1. If they're returned to outside applications, no-one knows what
>         they mean.
>      2. Eventually they'll clash with the ever expanding standard error
>         codes.
> 
> The problem error code in question is ETASK.  I've replaced this by
> ECOMM (communications error on send) a network error code that seems to
> most closely relay what ETASK meant.

Yay, cleanups :)

Acked-by: Darrick J. Wong <djwong@us.ibm.com>
