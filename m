From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [2.6 patch] scsi_transport_iscsi.c: make 2 functions static
Date: Thu, 14 Feb 2008 12:30:43 -0600
Message-ID: <47B488D3.1030801@cs.wisc.edu>
References: <20080213213017.GA3383@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43501 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760579AbYBNSbG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Feb 2008 13:31:06 -0500
In-Reply-To: <20080213213017.GA3383@cs181133002.pp.htv.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch makes the following needlessly global functions static:
> - __iscsi_unblock_session()
> - iscsi_session_state_name()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 

Looks good. Thanks.

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
