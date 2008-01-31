From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [BUG?] GDTH driver not working after upgrade to 2.6.24
Date: Thu, 31 Jan 2008 17:39:09 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801311736110.4864@fbirervta.pbzchgretzou.qr>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com>
 <47A1ABF8.4050408@upb.de> <47A1C0A5.7090303@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41921 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYAaQjK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 11:39:10 -0500
In-Reply-To: <47A1C0A5.7090303@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: =?ISO-8859-15?Q?Sven_K=F6hler?= <skoehler@upb.de>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <matthew@wil.cx>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org

Hi,

On Jan 31 2008 14:35, Boaz Harrosh wrote:
>
>Thanks, Perhaps someone else then. 
>Anyone with gdth HW that can test patches?

Is bisecting down the existing chain and finding the bad commit 
sufficient? (I also take new patches.)

>Your lspci said: "Intel Corporation RAID Controller" Matthew
>is there a gdth card lying around in an Intel lab near you?
>
>James do we need to mark gdth BROKEN for 2.6.24 and higher?

I say revert it for the time being.
