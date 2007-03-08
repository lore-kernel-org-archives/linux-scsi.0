From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: WRITE BUFFER commands through SG_IO getting rounded up to sector
 past 32k
Date: Thu, 08 Mar 2007 16:53:24 -0600
Message-ID: <45F093E4.9060805@cs.wisc.edu>
References: <45EE00F0.2010702@gmail.com> <45EE09A6.7030004@cs.wisc.edu> <45F08737.3060100@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36635 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030840AbXCHWxb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Mar 2007 17:53:31 -0500
In-Reply-To: <45F08737.3060100@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aravind Parchuri <aravind.parchuri@gmail.com>
Cc: linux-scsi@vger.kernel.org

Aravind Parchuri wrote:
> The patch has some problem. While ioctls with dxfer_len < 32k still make
> it through properly, the problematic ones now show up in open-iscsi's
> queuecommand with request_bufflen = 0. I'm not sure what the problem is
> now.
> 

Could you send the sg and iscsi log output with the patch?
