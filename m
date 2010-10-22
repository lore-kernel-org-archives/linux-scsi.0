From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [USB] Use normalized sense when emulating autosense
Date: Fri, 22 Oct 2010 14:13:53 -0700 (PDT)
Message-ID: <177615.57592.qm@web31810.mail.mud.yahoo.com>
References: <Pine.LNX.4.44L0.1010221029430.1529-100000@iolanthe.rowland.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31810.mail.mud.yahoo.com ([68.142.207.73]:37995 "HELO
	web31810.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753444Ab0JVVNy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2010 17:13:54 -0400
In-Reply-To: <Pine.LNX.4.44L0.1010221029430.1529-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

--- On Fri, 10/22/10, Alan Stern <stern@rowland.harvard.edu> wrote:
> What about the Filemark and ILI tests?=A0 You mustn't
> get rid of them;=20
> they are needed for tape drives.

I've resubmitted the patch.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
