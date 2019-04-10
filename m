From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] usb: uas: fix usb subsystem hang after power off hub port
Date: Tue, 09 Apr 2019 22:11:06 -0400
Message-ID: <yq1lg0imwxx.fsf@oracle.com>
References: <Pine.LNX.4.44L0.1904091014570.1599-100000@iolanthe.rowland.org>
        <1554823007.161891.6.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1554823007.161891.6.camel@acm.org> (Bart Van Assche's message of
        "Tue, 09 Apr 2019 08:16:47 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kento.A.Kobayashi@sony.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, Oliver Neukum <oneukum@suse.com>, gregkh@linuxfoundation.org, USB Storage list <usb-storage@lists.one-eyed-alien.net>, Jacky.Cao@sony.com, Kernel development list <linux-kernel@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Bart,

> From which context does that unbind happen? From inside a SCSI EH
> callback or from the context of a workqueue? I think the former is not
> allowed but that the latter is allowed. The SRP initiator driver
> (ib_srp.c) follows the latter approach.

Yeah. It's better to punt the actual tear down.

-- 
Martin K. Petersen	Oracle Linux Engineering
