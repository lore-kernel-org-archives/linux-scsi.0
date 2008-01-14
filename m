From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 5/10] lpfc 8.2.4 : Make lpfc legacy I/O port free
Date: Mon, 14 Jan 2008 09:06:00 -0500
Message-ID: <478B6C48.4020302@emulex.com>
References: <1200034380.27954.23.camel@localhost.localdomain> <1200073924.3286.40.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:48583 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197AbYANOGK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jan 2008 09:06:10 -0500
In-Reply-To: <1200073924.3286.40.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> You didn't check the diffstat of this one:
> 
>  lpfc_init.c      |   11 
>  lpfc_init.c.orig | 2475 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 2481 insertions(+), 5 deletions(-)
> 
> I've manually removed all references to the lpfc_init.c.orig file that
> popped into existence with this patch and was deleted with the
> subsequent one.
> 
> James

(grumble...)  Thank You James... That was the action that was needed.

-- james s
