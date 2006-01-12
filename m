From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: cdrecord: Cannot allocate memory. Cannot get SCSI I/O buffer.
Date: Thu, 12 Jan 2006 13:30:05 +0100
Message-ID: <m3psmxtyr6.fsf@merlin.emma.line.org>
References: <200601121322.17458.T.Maguin@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.21]:6551 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1030399AbWALMaO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 07:30:14 -0500
In-Reply-To: <200601121322.17458.T.Maguin@web.de> (Thomas Maguin's message of
	"Thu, 12 Jan 2006 13:21:58 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: T.Maguin@web.de
Cc: linux-scsi@vger.kernel.org

Thomas Maguin <T.Maguin@web.de> writes:

> cdrecord 2.01.01_alpha04 without any patches is working fine as root.
>
> As user  cdrecord dev=ATA:1,0,0 blank=fast  results in:
> cdrecord: Cannot allocate memory. Cannot get SCSI I/O buffer
>
> The user is in group burning, the rights are set as with 2.01.01_alpha01, 
> where user burning was possible. kernel is 2.6.14-nitro2.

-- 
Matthias Andree
