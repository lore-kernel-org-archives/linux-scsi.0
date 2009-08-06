From: Thomas Georgiou <tageorgiou@gmail.com>
Subject: Re: QLA2200 causes kernel bug
Date: Thu, 6 Aug 2009 13:12:42 -0400
Message-ID: <6e4c20e70908061012y3fa907aduca4f706cf5ccaa5a@mail.gmail.com>
References: <6e4c20e70908060828xd4a6a8fh801e1d456c39a5f@mail.gmail.com>
	 <20090806164925.GO2453@plap4-2.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:50365 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373AbZHFRMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2009 13:12:42 -0400
Received: by mail-yx0-f175.google.com with SMTP id 5so1224531yxe.33
        for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2009 10:12:43 -0700 (PDT)
In-Reply-To: <20090806164925.GO2453@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Here is the dmesg log: http://www.tjhsst.edu/~2010tgeorgio/fclogs/dmesg=
3.log
Here is the complete syslog file, with more junk in it:
http://www.tjhsst.edu/~2010tgeorgio/fclogs/messages3.log
I will reboot the server and enable error logging.

Could this issues be caused by enclosures have conflicting scsi ids?

On Thu, Aug 6, 2009 at 12:49 PM, Andrew
Vasquez<andrew.vasquez@qlogic.com> wrote:
> Thomas, could you forward the full messages file? =A0I'm interested i=
n
> seeing what series of events led up to the BUG_ON(). =A0The snippets
> here and in the bugzilla only document the failing point BUG_ON().
> Also, could you get a test run with the driver error-logging enabled
> as well:
>
> =A0 =A0 =A0 =A0$ modprobe -v qla2xxx ql2xextended_error_logging=3D1
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
