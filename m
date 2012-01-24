From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [LSF/MM TOPIC] a few storage topics
Date: Tue, 24 Jan 2012 14:48:54 -0500
Message-ID: <4F1F0B26.301@interlog.com>
References: <CABE8wws67dn0fwhTCs_XqH0g_CxGuT+hPQH9cVFe1xx5t_O9Jw@mail.gmail.com> <20120117200609.GA7933@redhat.com> <yq162g13rsg.fsf@sermon.lab.mkp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <yq162g13rsg.fsf@sermon.lab.mkp.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12-01-24 12:59 PM, Martin K. Petersen wrote:
>>>>>> "Mike" == Mike Snitzer<snitzer@redhat.com>  writes:
>
> Mike>  1) expose WRITE SAME via higher level interface (ala
> Mike>     sb_issue_discard) for more efficient zeroing on SCSI devices
> Mike>     that support it
>
> I actually thought I had submitted those patches as part of the thin
> provisioning update. Looks like I held them back for some reason. I'll
> check my notes to figure out why and get the kit merged forward ASAP!
>
>
> Mike>  4) is anyone working on an interface to GET LBA STATUS?
> Mike>     - Martin Petersen added GET LBA STATUS support to scsi_debug,
> Mike>       but is there a vision for how tools (e.g. pvmove) could
> Mike>       access such info in a uniform way across different vendors'
> Mike>       storage?
>
> I hadn't thought of that use case. Going to be a bit tricky given how
> GET LBA STATUS works...

What's new in ACS-3 (t13.org ATA Command Set):
.....
   f10138r6 Adds the ability for the device to return a
            list of the LBAs that are currently trimmed.

So it looks like t13.org are adding a GET LBA STATUS type facility.
That in turn should lead to a SAT-3 (SCSI to ATA Translation)
definition of a mapping between both facilities.

Doug Gilbert


