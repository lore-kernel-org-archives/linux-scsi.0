From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND v2 0/2] scsi: Port buslogic driver to 64 bits
Date: Mon, 24 Jun 2013 13:55:13 -0700
Message-ID: <1372107313.2013.81.camel@dabdike.int.hansenpartnership.com>
References: <cover.1368754558.git.khalid.aziz@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1368754558.git.khalid.aziz@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-06-24 at 14:25 -0600, Khalid Aziz wrote:
> This patchset ports buslogic driver to 64-bit.

OK, thought long and hard about this., I'll take it on the proviso that
you're the new buslogic maintainer.  The reason being that without
someone to sort through any bug reports, the only option I have on a bug
which is in the rework but not the original would be to revert to the
original.

James
