From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs
	directories.
Date: Wed, 27 May 2009 02:02:15 +0200
Message-ID: <ac3eb2510905261702n44c785a0hd0e59b5deb0fe903@mail.gmail.com>
References: <ac3eb2510905261413r54e5bb18n7faf888aa55d8830@mail.gmail.com>
	<Pine.LNX.4.44L0.0905261756390.11998-100000@iolanthe.rowland.org>
	<ac3eb2510905261503k32db6197m84d1e78858e53da1@mail.gmail.com>
	<1243381772.2815.96.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1243381772.2815.96.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 27, 2009 at 01:49, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:

> OK ... perhaps we have to wait a little harder: try this; it waits until
> all the targets have disappeared from visibility via an event.

That seems to work fine here.

Thanks,
Kay
