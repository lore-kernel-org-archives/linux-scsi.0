From: Scott Merritt <Scsi@PragmaSoft.com>
Subject: Re: [PATCH] SCSI hotplug support
Date: Tue, 15 Oct 2002 14:22:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015142254.09a5770f.Scsi@PragmaSoft.com>
References: <200210142107.g9EL7IX04354@localhost.localdomain>
	<200210150019.53689.oliver@neukum.name>
	<20021015002252.GE1274@redhat.com>
	<200210150953.29905.oliver@neukum.name>
	<20021015143533.GA4288@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021015143533.GA4288@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 15 Oct 2002 10:35:33 -0400
Doug Ledford <dledford@redhat.com> wrote:

> Now, please, someone tell me why everyone is whining about user space 
> doing so little to accomplish what the much larger patch that was ...

Not *everyone* is whining about funnelling the scsi attachments back through user space :)  I *much* prefer this approach as it makes it easier for users to install extra/different processing if necessary.  In some sense, this is similar to my previous objections about the scsi drivers insisting on automatically reading the partition tables whenever they (think) they have encountered a scsi block device.
