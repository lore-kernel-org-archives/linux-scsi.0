From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 08/17] scsi: replace remaining __FUNCTION__ occurrences
Date: Fri, 28 Mar 2008 17:35:04 -0500
Message-ID: <1206743704.3662.61.camel@localhost.localdomain>
References: <200803282148.m2SLmbog012237@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58446 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353AbYC1WfK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 18:35:10 -0400
In-Reply-To: <200803282148.m2SLmbog012237@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, harvey.harrison@gmail.com

On Fri, 2008-03-28 at 14:48 -0700, akpm@linux-foundation.org wrote:
> From: Harvey Harrison <harvey.harrison@gmail.com>
> 
> __FUNCTION__ is gcc-specific, use __func__

I thought we basically agreed there was no point to this since if it
ever became an issue you can do 

#define __FUNCTION__ __func__

inside the include/compiler-xxx.h file

James


