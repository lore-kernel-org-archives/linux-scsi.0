From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH] Fixup aic7xxx firmware build
Date: Fri, 25 Apr 2008 04:25:37 +0200
Message-ID: <200804250425.37755.vda.linux@googlemail.com>
References: <480F03E5.9050000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:55455 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbYDYC0t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 22:26:49 -0400
Received: by fg-out-1718.google.com with SMTP id l27so3377108fgb.17
        for <linux-scsi@vger.kernel.org>; Thu, 24 Apr 2008 19:26:48 -0700 (PDT)
In-Reply-To: <480F03E5.9050000@suse.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wednesday 23 April 2008 11:39, Hannes Reinecke wrote:
> the last aicasm fix uncovered a flaw in the aicasm code,
> ie the range checking in type_check() was never called
> properly.
> This patch fixes this up and also disables the unused
> 16bit instruction.

I can confirm that it fixed firmware build for me.
--
vda
