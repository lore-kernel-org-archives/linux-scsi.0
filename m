From: Andy Grover <agrover@redhat.com>
Subject: Re: [RFC 1/2] target: Add documentation on the target userspace pass-through
 driver
Date: Tue, 02 Sep 2014 15:06:14 -0700
Message-ID: <54063F56.9090606@redhat.com>
References: <1404241875-29164-1-git-send-email-agrover@redhat.com> <1404241875-29164-2-git-send-email-agrover@redhat.com> <20140830173510.GA11820@redhat.com> <54037C46.1050601@redhat.com> <20140831212257.GO1302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20140831212257.GO1302@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org, shli@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/31/2014 02:22 PM, Richard W.M. Jones wrote:
> Reading this several times, I now think I get what it's trying to say,
> but I think it needs to introduces the terms (as the Economist style
> does).  Something like this:
>
>    "TCM is the new name for LIO, an in-kernel iSCSI target (server).
>    Existing TCM targets run in the kernel.  TCMU (TCM in Userspace)
>    allows userspace programs to be written which act as iSCSI targets.
>    This document describes the design.
>
>    The existing kernel provides modules for different SCSI transport
>    protocols.  TCM also modularizes the data storage.  There are
>    existing modules for file, block device, RAM or using another SCSI
>    device as storage.  These are called "backstores" or "storage
>    engines".  These built-in modules are implemented entirely as kernel
>    code."
>
> And hopefully having defined a bit of background, the rest of the
> document just flows nicely:

Thanks much! I've put this in the doc, and will hopefully send out a 
final patchset for inclusion with the new text in the next week or so.

<begin naming potential-bikeshed wasteoftime>

The only change I made was "another" instead of "the new name" -- 
because to be honest I don't know if there was actually an attempt at a 
name change, and if so if it was successful or not :) LIO seems to have 
stuck, but TCM seems to refer just to the "backend" part of LIO.

<end bikeshed>

Thanks again -- Andy
