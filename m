From: "Bryan Henderson" <hbryan@us.ibm.com>
Subject: Re: /proc/scsi/map
Date: Mon, 17 Jun 2002 15:06:49 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFFB97DE4B.B393E7EC-ON87256BDB.00791936@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


>No. I was not wanting to give a numbering to SCSI devices. They don't
have.
>The high level driver attached to them however do. That's what is
reported.

Ah yes.  It's been a long time since I looked at how the SCSI drivers are
put together, and I remembered it wrong.

The basis for my discomfort was just what appeared in the example to be
special treatment of sg.  Patrick's comments more closely reflect what I
would have said if I knew what I was talking about.

What would the output look like in a system that has no sg driver?



