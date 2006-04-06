From: alan <alan@clueserver.org>
Subject: Re: Question: how to redirect Ctrl-Alt-F4 output to serial during
 installation?
Date: Thu, 6 Apr 2006 15:16:00 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0604061514500.7269@blackbox.fnordora.org>
References: <890BF3111FB9484E9526987D912B261901BCB4@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:51615 "EHLO
	clueserver.org") by vger.kernel.org with ESMTP id S1751343AbWDFWQB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Apr 2006 18:16:01 -0400
In-Reply-To: <890BF3111FB9484E9526987D912B261901BCB4@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: "Ju, Seokmann" <Seokmann.Ju@engenio.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Thu, 6 Apr 2006, Ju, Seokmann wrote:

> Hi,
>
> During installation, I'm seeing all messages coming from SCSI HBA driver
> displayed on Ctrl-Alt-F4 (not on console).
> I would like to capture/analyze all messages stored in file.
> Is there anyway that I could redirect Ctrl-Alt-F4 output to serial?

I would try redirecting the kernel messages to the serial device of choice 
via /etc/syslog.conf.

-- 
"Remember there is a big difference between kneeling down and bending over." - Frank Zappa
