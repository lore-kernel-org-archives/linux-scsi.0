From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: Document generic scsi device attributes
Date: Fri, 19 Aug 2011 11:21:47 -0400
Message-ID: <4E4E7F8B.7020502@interlog.com>
References: <20110819144427.15191.54676.stgit@beardog.cce.hp.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:50054 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab1HSPVx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Aug 2011 11:21:53 -0400
In-Reply-To: <20110819144427.15191.54676.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, stephenmcameron@gmail.com, akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 11-08-19 10:44 AM, Stephen M. Cameron wrote:
> From: Stephen M. Cameron<scameron@beardog.cce.hp.com>
>

<snip>

> +What:           /sys/class/scsi_device/..../device/modalias
> +Date:           April, 2007
> +KernelVersion:  Unknown
> +Contact:        James Bottomley<James.Bottomley@HansenPartnership.com>
> +Description:
> +		This read only string value contains a string of the form
> +		"scsi:t-0xXX" where "XX" are two hex digits representing the
> +		SCSI device type.  See also the "type" attribute and table 47
> +		in section 8.2.5.1 "Standard INQUIRY data" of the SCSI-2
> +		specification.

My copy of SCSI-2 is draft 10b from 1989 and it doesn't have a
section 8.2.5.1 . Since SCSI-2 was withdrawn over 10 years
ago perhaps you could use a more recent reference. [I see
webstore.ansi.org still sells the SCSI-2 standard for $30 .]

SPC-3 is a standard [ANSI INCITS 408-2005; ISO/IEC 14776-453]
and the relevant section, judging from its last draft, would
be table 83 in section 6.4.2 . And it is now called the
"peripheral device type".

Doug Gilbert

