From: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
Subject: Re: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
Date: Thu, 07 Jan 2010 21:34:06 +0100
Message-ID: <4B46453E.1060206@googlemail.com>
References: <4B3BDB66.6000008@googlemail.com> <4B4632BF.4070806@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:49422 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab0AGUdy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2010 15:33:54 -0500
In-Reply-To: <4B4632BF.4070806@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On 01/07/10 20:15, Jeff Garzik wrote:
> I need a little bit more detail than an unqualified statement...  Did
> you audit all paths leading to this code point?

Yes, and my two systems running fine with the patch, no oops or panic's.
