From: Osamu Tomita <tomita@cinet.co.jp>
Subject: Re: [PATCH] scsi_error fix
Date: Sun, 09 Mar 2003 10:41:56 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E6A9BE4.D29D3E67@cinet.co.jp>
References: <UTC200303072019.h27KJXX12872.aeb@smtp.cwi.nl>
		<20030307211732.GA1148@beaverton.ibm.com> <1047075661.3444.27.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Andries.Brouwer@cwi.nl, Patrick Mansfield <patmans@us.ibm.com>, linux-kernel@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, torvalds@transmeta.com

James Bottomley wrote:
> This is against vanilla 2.5.64 (you have to take Andries work around out
> to see the fix in the BK version).

Thanks!
My old PC98 box with wd33c93 and SCSI-1 HD/CD re-works fine
after apllied you patch.
With cset-1.1099 patch, kernel can boot but mis detect SCSI-1
CD drive.

Regards,
Osamu Tomita
