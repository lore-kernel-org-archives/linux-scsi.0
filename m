From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
Date: Wed, 27 May 2009 11:00:17 -0700
Message-ID: <m1ljoi1l5a.fsf@fess.ebiederm.org>
References: <Pine.LNX.4.44L0.0905262214370.21274-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0905262214370.21274-100000@netrider.rowland.org> (Alan Stern's message of "Tue\, 26 May 2009 22\:17\:41 -0400 \(EDT\)")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>
List-Id: linux-scsi@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Wed, 27 May 2009, Kay Sievers wrote:
>
>> On Wed, May 27, 2009 at 01:49, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>> 
>> > OK ... perhaps we have to wait a little harder: try this; it waits until
>> > all the targets have disappeared from visibility via an event.
>> 
>> That seems to work fine here.
>
> It's good for a short-term fix.  For the longer term, I still think 
> it's a mistake to wait for the sdevs to be released before deleting the 
> target.  It gives user programs the ability to block the host-removal 
> thread indefinitely.

How can user programs block removal indefinitely today?

Eric
