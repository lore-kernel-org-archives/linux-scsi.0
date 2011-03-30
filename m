From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
Date: Wed, 30 Mar 2011 07:13:43 -0400
Message-ID: <E32BEFA9-15DE-4169-B313-095920A4DF7A@mit.edu>
References: <1301373398.2590.20.camel@mulgrave.site> <4D91BF90.8070909@redhat.com> <1301445210.2731.14.camel@mingming-laptop> <20110330021742.GL3008@dastard>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110330021742.GL3008@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Mingming Cao <cmm@us.ibm.com>, Ric Wheeler <rwheeler@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, lsf@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org


On Mar 29, 2011, at 10:17 PM, Dave Chinner wrote:

> Direct IO semantics have always been that the application is allowed
> to overlap IO to the same range if it wants to. The result is
> undefined (just like issuing overlapping reads and writes to a disk
> at the same time) so it's the application's responsibility to avoid
> overlapping IO if it is a problem.

Even if the overlapping read/writes are taking place in different processes?

DIO has never been standardized, and was originally implemented as gentleman's agreements between various database manufacturers and proprietary unix vendors.  The lack of formal specifications of what applications are guaranteed to receive is unfortunate....

-- Ted

