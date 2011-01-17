From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [LSF/MM TOPIC] update on discard support & testing with vendors
Date: Mon, 17 Jan 2011 18:18:30 -0500
Message-ID: <AANLkTikihfUrLF3mMtMqYFsxqDgeQE=bv-=MN-ToY6R6@mail.gmail.com>
References: <4D345637.6000207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4D345637.6000207@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: lsf-pc@lists.linuxfoundation.org, linux-fsdevel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 17, 2011 at 9:46 AM, Ric Wheeler <rwheeler@redhat.com> wrote:
>
> I would like to spend some time reviewing where we stand with the discard
> support - specifically review where we do in the stack (creation time,
> fine-grained during deletions, other bulk times), how the options perform
> and any performance results we have with various classes of devices (SCSI
> and SSD).
>
> Similar interest in how the topology/alignment support has worked out.
>
> Both topics took a lot of effort on our part and I expect that we are just
> now going to be hitting the point where hardware vendors take us seriously
> enough & are starting to test....

+1

Would be nice to hear from the stake holders at the various storage
vendors (or users who have experience with said vendors'
support/performance or lack thereof).

At the last LSF, Martin and I spoke of the topology/alignment support
that was added but it generated little discussion.  Could be such
detail was too early, maybe this time around vendors will be more
vocal.

One nagging sticking point for some storage vendors is the Linux
requirement that a LUN advertise itself as SPC-3 compliant (in order
for Linux's SCSI layer to issue a READ CAPACITY 16, etc).

Discard is more sexy so I'd expect a bit more discussion for that
topic.  And again, BLOCK LIMITS VPD PAGE requirements have kept some
vendors from implementing UNMAP support (sticking with WRITE SAME w/
UNMAP bit set).

Mike
