From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: tmscsim broken on amd64 with 2.6.5?
Date: Mon, 12 Apr 2004 07:38:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <407A7F9B.2030604@pobox.com>
References: <Pine.LNX.4.44.0404121301110.2267-200000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:48834 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262849AbUDLLiR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Apr 2004 07:38:17 -0400
In-Reply-To: <Pine.LNX.4.44.0404121301110.2267-200000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christian Roessner <info@roessner-net.com>, linux-scsi@vger.kernel.org

Guennadi Liakhovetski wrote:
> Hi
> 
> Can you try the attached patch, please. If it still doesn't work, could
> you add something like
> kern.*                          -/var/log/tmscsim.log
> to your /etc/syslog.conf, do killall -HUP syslogd, and send me the log
> starting from insertion of the module. Also a
> lspci -vvxxx -s 0000:01:07.0
> (I hope the syntax is correct for your platform).

Good catch, definitely a bug.

Would be nice if we could kill the non-standard types (ULONG, etc.) from 
the driver.

	Jeff




