From: Dmitry Torokhov <dtor_core@ameritech.net>
Subject: Re: [BK PATCH] SCSI updates for 2.6.9
Date: Mon, 18 Oct 2004 23:41:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200410182341.13648.dtor_core@ameritech.net>
References: <1098137016.2011.339.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp800.mail.sc5.yahoo.com ([66.163.168.179]:51065 "HELO
	smtp800.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S267936AbUJSElQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Oct 2004 00:41:16 -0400
In-Reply-To: <1098137016.2011.339.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, willy@debian.org, Linux1394-Devel <linux1394-devel@lists.sourceforge.net>

On Monday 18 October 2004 05:03 pm, James Bottomley wrote:

> Matthew Wilcox:
>   o Add SPI-5 constants to scsi.h

This breaks Firewire SBP2 build:

  CC [M]  drivers/ieee1394/sbp2.o
In file included from drivers/ieee1394/sbp2.c:78:
drivers/ieee1394/sbp2.h:61:1: warning: "ABORT_TASK_SET" redefined
In file included from drivers/scsi/scsi.h:31,
                 from drivers/ieee1394/sbp2.c:67:
include/scsi/scsi.h:255:1: warning: this is the location of the previous definition
In file included from drivers/ieee1394/sbp2.c:78:
drivers/ieee1394/sbp2.h:62:1: warning: "LOGICAL_UNIT_RESET" redefined
In file included from drivers/scsi/scsi.h:31,
                 from drivers/ieee1394/sbp2.c:67:
include/scsi/scsi.h:267:1: warning: this is the location of the previous definition

It looks like firewire has its own set of commands with conflicting names.
Who should win?

-- 
Dmitry
