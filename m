From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [2.6 patch] make lpfc_disable_node() static
Date: Thu, 14 Feb 2008 16:47:04 -0500
Message-ID: <47B4B6D8.6000204@emulex.com>
References: <20080214212402.GF23227@cs181133002.pp.htv.fi>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:44261 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbYBNVr0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2008 16:47:26 -0500
In-Reply-To: <20080214212402.GF23227@cs181133002.pp.htv.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org



Adrian Bunk wrote:
> This patch makes theneedlessly global lpfc_disable_node() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---

ACK

-- james s

