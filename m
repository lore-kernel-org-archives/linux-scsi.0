From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Kernel 3.10.3 "reset SuperSpeed USB device number 2 using xhci_hcd"
Date: Mon, 29 Jul 2013 11:28:19 -0400
Message-ID: <yq1k3k9jsh8.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.44L0.1307291108460.1479-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1307291108460.1479-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Mon, 29 Jul 2013 11:23:01 -0400 (EDT)")
Sender: stable-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Stuart Foster <smf.linux@ntlworld.com>, Ed Tomlinson <edt@aei.ca>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:

Alan> In the case of these bug reports, the scsi_report_opcode() call
Alan> returns -EINVAL.

Oh, right. Because I actually do an explicit SCSI version check in
scsi_report_opcode(). That's OK, then...

-- 
Martin K. Petersen	Oracle Linux Engineering
