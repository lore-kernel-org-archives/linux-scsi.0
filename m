From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [GIT PULL] first round of SCSI updates for the 3.1 merge window
Date: Fri, 28 Oct 2011 12:37:44 +0200
Message-ID: <CAO+b5-poCGta55VVZCLc_YsJDyZzGHs=zmvFT8pRqns-xw5vaQ@mail.gmail.com>
References: <1319782638.22700.8.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1319782638.22700.8.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 28, 2011 at 8:17 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> This represents the usual round of driver updates [ ... ]

Have these two patches perhaps been overlooked ?
* Make scsi_free_queue() kill pending SCSI commands, which fixes a
kernel deadlock that is easy to trigger from user space
(http://marc.info/?l=linux-scsi&m=131680195721932).
* srp_transport: Fix atttribute registration race
(http://marc.info/?l=linux-rdma&m=131921626507904).

Bart.
