From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: dev nodes assignement ?
Date: Wed, 29 Jan 2003 10:59:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFA0A98C43.F47155A2-ON87256CBD.00627856-88256CBD.0062D452@us.ibm.com>
References: <20030129110004.22210.qmail@web20421.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030129110004.22210.qmail@web20421.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: devnetfs <devnetfs@yahoo.com>
Cc: linux-scsi@vger.kernel.org





>Is /dev/sdX scsi dev node assignment based *only* on the pci-slot
>the HBA's are in? or also upon the order in which the LLDD is loaded?

First of all, let's acknowledge that the /dev/sdX device special file
assignments are done manually by the user and are permanent.  /dev/sdX is
assigned to a major and minor number.

So the actual question is about minor number assignments.

>... OR
>Does each LLDD do a pci-scan and assign [minor numbers] for HBA's that it
>can handle -- in which case the order of LLDD getting loaded is also
>important in deciding the [minor number].

Yes.

