From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: SAS Management Protocol (SMP) on Windows
Date: Mon, 22 Jul 2013 09:43:41 -0400
Message-ID: <51ED370D.2060900@interlog.com>
References: <loom.20130722T100620-437@post.gmane.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:56087 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558Ab3GVNoI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Jul 2013 09:44:08 -0400
In-Reply-To: <loom.20130722T100620-437@post.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hugh Chin <hung36987@gmail.com>
Cc: linux-scsi@vger.kernel.org

On 13-07-22 04:26 AM, Hugh Chin wrote:
> I'm developing SMP application by Python. I've ran it on Linux, it works
> fine. But now I have to run it on Windows. Of course, it didn't work.
>
> So far I know that Windows seems doesn't have bsg driver. But I'm not sure.
> I want to know is there any way can run SMP application on Windows?
>
> My English is poor, so if you had something misunderstanding. Please let me
> know.

My smp_utils package is written for Linux and ported to
FreeBSD using the latter's CAM interface recently expanded
to pass-through SMP commands. I'm not aware of any such
generic SMP pass-through for Windows but I'd be happy
to be corrected.

Apart from that, this is probably the wrong list to be
discussing this subject.

Doug Gilbert


