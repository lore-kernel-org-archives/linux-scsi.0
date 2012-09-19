From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH] qla2xxx: Fix endianness of task management response code
Date: Wed, 19 Sep 2012 07:09:22 -0700
Message-ID: <CAG4TOxMffy5ygGJ2ba8jFNmLx49e6p72RRgt8t=Sts1ypQofkA@mail.gmail.com>
References: <1348006256-23551-1-git-send-email-roland@kernel.org> <1348041561.2479.14.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1348041561.2479.14.camel@dabdike.int.hansenpartnership.com>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Arun Easi <arun.easi@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 19, 2012 at 12:59 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> Is this also true on Big Endian Hardware?  Because the fix you have
> assumes that the TIO IOCB with SCSI status mode 1 should be CPU
> endian ... that doesn't look right since this is passed directly over
> the PCI bus (and the PCI bus is little endian), so shouldn't the correct
> fix be to replace cpu_to_be32 with cpu_to_le32?

After my patch the assignment is to a u8, and that byte is in the right
place in memory.  So I don't think there's any endianness bug.

 - R.
