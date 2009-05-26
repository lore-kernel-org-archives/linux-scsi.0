From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs
	directories.
Date: Tue, 26 May 2009 23:13:26 +0200
Message-ID: <ac3eb2510905261413r54e5bb18n7faf888aa55d8830@mail.gmail.com>
References: <Pine.LNX.4.44L0.0905261508210.9278-100000@iolanthe.rowland.org>
	<1243372199.2815.77.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1243372199.2815.77.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 26, 2009 at 23:09, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2009-05-26 at 15:29 -0400, Alan Stern wrote:

>> If you don't mind trashing some more ext3 root filesystems :-) you c=
an
>> try this patch. =C2=A0It's almost certainly not quite the right thin=
g to do
>> and I have probably messed up the target's reference counting, but
>> maybe it's a step in the right direction.

> It's hard to follow the problem without full context, but if I
> understand correctly the problem is you want all the target directori=
es
> removed before you call device_del() on the host and the thing that g=
ets
> in the way is the necessary user context removal of the host. =C2=A0S=
o a
> simple solution, rather than mucking with the way it works, is to wai=
t
> for the workqueues to complete. =C2=A0Does this fix it?

Ok, I copied my newly installed system to another disks, to have a
root filesytem to trash again by this bug. :)

Which of your patches should I try?

Thanks,
Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
